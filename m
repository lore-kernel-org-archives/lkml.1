Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbZAJAtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbZAJAtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbZAJAtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:49:32 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55275 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZAJAtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:49:31 -0500
Message-ID: <8c182b969c7f3c9c583b879709767ed7.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <6599ad830901091623i2c3f6ce1ma88c845074b7c013@mail.gmail.com>
References: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com>
    <20090108182817.2c393351.kamezawa.hiroyu@jp.fujitsu.com>
    <6599ad830901091623i2c3f6ce1ma88c845074b7c013@mail.gmail.com>
Date: Sat, 10 Jan 2009 09:49:28 +0900 (JST)
Subject: Re: [RFC][PATCH 1/4] cgroup: support per cgroup subsys state ID
 (CSS  ID)
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage さんは書きました：
> On Thu, Jan 8, 2009 at 1:28 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> + *
>> + * Looking up and scanning function should be called under
>> rcu_read_lock().
>> + * Taking cgroup_mutex()/hierarchy_mutex() is not necessary for all
>> calls.
>
> Can you clarify here - do you mean "not necessary for any calls"
> (calls to what?) or "not necessary for some calls"? I presume the
> former.
>
Ah, sorry bad text.

not necessary for any calls related to css_id.

-Kame


