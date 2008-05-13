Return-Path: <linux-kernel-owner+w=401wt.eu-S1761918AbYEMVUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918AbYEMVUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759781AbYEMVUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:20:46 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:42434 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759518AbYEMVUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:20:45 -0400
Date: Tue, 13 May 2008 23:20:43 +0200
From: Arnd Hannemann <arnd@arndnet.de>
Subject: Re: WD doesn`t use disks with Linux - was Re: Re:Western Digital
 GreenPower drives and Linux
In-reply-to: <003201c8b53c$67ff02d0$6400a8c0@bui.materna.com>
To: Roland <devzero@web.de>
Cc: tvrtko@ursulin.net, pernegger@gmail.com, snitzer@gmail.com,
       jengelh@computergmbh.de, zorglub_olsen@hotmail.com,
       renatoyamane@mandic.com.br, linux-kernel@vger.kernel.org
Message-id: <482A062B.3010308@arndnet.de>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
X-IronPort-AV: E=Sophos;i="4.27,481,1204498800";   d="scan'208";a="66135790"
References: <003201c8b53c$67ff02d0$6400a8c0@bui.materna.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland wrote:
>> BTW, WD's tech support has gone silent so chances for an easier
>> solution are not so great.
>>
>> Tvrtko
>
> I`ve got a real funky response from WD support  today, i`d like to
> share here.
> This is just too weird....
>
> After asking if they could give a comment if the problem with the high
> Load_Cycle_Count may be an issue of their drives or an issue of Linux
> i got:
>
> ------
> Dear......
> The problem is, that we actually don`t use the disks with Linux. I´m
> sorry that i cannot send further information to you.
>
> Sincery yours
> <insert support employee name here>
> Western Digital Service and Support
> ------
> (translated from german)

Well the answer was probably just from a first level support person so
nothing one should get excited about.
Anyway to the high Load_Cycle_Count; if I understood the technology
correctly the WD GreenPower drives are exactly "Green" because they
unload the heads on a plastic ramp (no landing zone!) quite often during
longer idle periods. Thus they can power off the positioning logic and
actuator of the heads. -> safe Power
This also explains why the power usage under seek is comparable with
other "non-green" drives...

<snipped a lot of stuff>
> 193 Load_Cycle_Count 0x0032 197 197 000 Old_age  Always  - 10233
my 1 TB drive has also a relative high value:

193 Load_Cycle_Count        0x0032   200   200   000    Old_age  
Always       -       2786


Just my 2 cents,
Arnd
||
