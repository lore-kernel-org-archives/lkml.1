Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbZB0XeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbZB0XeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 18:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZB0XeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 18:34:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46041 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbZB0XeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 18:34:08 -0500
Message-ID: <b0f5e75d938ffb61bdda7c88b962d3fe.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <b040c32a0902271213q3dd1931foc2b955d8a028eb6f@mail.gmail.com>
References: <20090227140537.390905c4.kamezawa.hiroyu@jp.fujitsu.com>
    <20090227162928.6225fc80.kamezawa.hiroyu@jp.fujitsu.com>
    <b040c32a0902271213q3dd1931foc2b955d8a028eb6f@mail.gmail.com>
Date: Sat, 28 Feb 2009 08:34:02 +0900 (JST)
Subject: Re: [PATCH] change cpuacct usage percpu format v2
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Ken Chen" <kenchen@google.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
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

Ken Chen さんは書きました：
> On Thu, Feb 26, 2009 at 11:29 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> cpuacct.usage_percpu shows per cpu usage information via cgroupfs.
>> It shows all "present" cpus information and "whose information ?"
>> is explained just by index of data implicitly.
>>
>> IIRC, there is physical cpu hotplug system and it can remove
>> cpus and change map. Considering a software which records
>> this information pediodically(like sar), its better to show id of cpu
>> in explict way.
>
> The new format carries a lot of overhead.  I would think user space
> software can record /sys/devices/system/cpu/present and use that to
> map cpu index.
>
"a lot of" ? I talking about cpu hotplug and reading another file as
/sys/devices/system/cpu/present every time before reading this file
gives much much much more overhead ;)

A program which handles this kind of information tend to ignore hotplug
event and continue to use informaton which it gathers at start-up and
will not see updated information....as libnuma etc.

Thanks,
-Kame



