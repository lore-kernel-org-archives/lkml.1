Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZBUApv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZBUApv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 19:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZBUApn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 19:45:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34493 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZBUApm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 19:45:42 -0500
Message-ID: <d7928a87d8c1bf661e3a3b64db9fa988.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <6599ad830902200822u6d453340me718bacac3925040@mail.gmail.com>
References: <20090220190223.e8b4f6a8.kamezawa.hiroyu@jp.fujitsu.com>
    <6599ad830902200822u6d453340me718bacac3925040@mail.gmail.com>
Date: Sat, 21 Feb 2009 09:45:33 +0900 (JST)
Subject: Re: Question for remount
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       lizf@cn.fujitsu.com, containers@lists.linux-foundation.org
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
> On Fri, Feb 20, 2009 at 2:02 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>> 2. /proc/mounts information of release_agent should be updated....
>>   when it's overwritten directly.
>
> Yes, definitely. But shouldn't that happen already?
> cgroup_show_options() reports the current value of
> root->release_agent_path in /proc/mounts. Is it possible that mount is
> actually storing/retrieving this information in /etc/mtab, which
> doesn't get updated?
>
Ah, you're right. /proc/mounts is updated but /etc/mtab is not updated.
Hmm..from man mount(1), /etc/mtab is not synchronized with /proc/mounts.
Do we need to allow release_agent override at remount ?

-Kame

