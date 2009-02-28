Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbZB1FZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbZB1FZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 00:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbZB1FZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 00:25:30 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36189 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZB1FZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 00:25:29 -0500
Message-ID: <cadbb09620a0d64c1bb3a24ce852c44d.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090228011115.GC28769@linux.vnet.ibm.com>
References: <20090227140537.390905c4.kamezawa.hiroyu@jp.fujitsu.com>
    <20090227162928.6225fc80.kamezawa.hiroyu@jp.fujitsu.com>
    <b040c32a0902271213q3dd1931foc2b955d8a028eb6f@mail.gmail.com>
    <b0f5e75d938ffb61bdda7c88b962d3fe.squirrel@webmail-b.css.fujitsu.com>
    <b040c32a0902271600h31785bb8q93acde59f5d15e3d@mail.gmail.com>
    <661fca240cb094bcf4d261ccebab9848.squirrel@webmail-b.css.fujitsu.com>
    <c73ef954d3030022416d249ba8fefe8e.squirrel@webmail-b.css.fujitsu.com>
    <20090228011115.GC28769@linux.vnet.ibm.com>
Date: Sat, 28 Feb 2009 14:25:22 +0900 (JST)
Subject: Re: [PATCH] change cpuacct usage percpu format v2
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Ken Chen" <kenchen@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>, mingo@elte.hu,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani wrote：
> On Sat, Feb 28, 2009 at 09:42:17AM +0900, KAMEZAWA Hiroyuki wrote:
>> KAMEZAWA Hiroyuki wrote：
>> BTW, current interface to reset cpuacct (write ops) just reset
>> specified level of cpuacct and will not clear other hierarchical levels.
>> Doesn't this behavior confuse software ?
>>
>
> hmmm. This got missed when we introduced hierarchy. But I wonder if it
> is needed?
>
IIUC, cpuacct.usage just shows sum of itself and all children's usage and
its own usage can be calclated by reading all usage of hierarchy.
So, reset ops seems to be a bit broken.
And by this, parent's usage can be smaller than children.

How about adding limitation as "you can clear usage only when there are no
children" ? Maybe not very strange limitaton under hierarchical system.


Thanks,
-Kame


