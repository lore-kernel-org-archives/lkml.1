Return-Path: <linux-kernel-owner+w=401wt.eu-S1761103AbYEMVA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761103AbYEMVA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758725AbYEMVAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:00:49 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:41568 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbYEMVAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:00:48 -0400
Message-ID: <003201c8b53c$67ff02d0$6400a8c0@bui.materna.com>
From: "Roland" <devzero@web.de>
To: <tvrtko@ursulin.net>, <pernegger@gmail.com>, <snitzer@gmail.com>,
       <jengelh@computergmbh.de>, <zorglub_olsen@hotmail.com>,
       <renatoyamane@mandic.com.br>
Cc: <linux-kernel@vger.kernel.org>
Subject: WD doesn`t use disks with Linux - was Re: Re:Western Digital GreenPower drives and Linux
Date: Tue, 13 May 2008 23:00:42 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Provags-ID: V01U2FsdGVkX19V3xKVMRfv/+8IBSkPeEG7dGxHSyvGvOEOixs/
	7qBY2tcAexWZHeJ27bpEURxudUmZyauw/30TlrTouNMXGfmzPa
	6+422g1mc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>BTW, WD's tech support has gone silent so chances for an easier solution 
>are not so great.
>
>Tvrtko

I`ve got a real funky response from WD support  today, i`d like to share 
here.
This is just too weird....

After asking if they could give a comment if the problem with the high 
Load_Cycle_Count may be an issue of their drives or an issue of Linux i got:

------
Dear......
The problem is, that we actually don`t use the disks with Linux. I´m sorry 
that i cannot send further information to you.

Sincery yours
<insert support employee name here>
Western Digital Service and Support
------
(translated from german)




So, WD sells enterprise SATA disks, optimizied for 24/7 & Raid array usage, 
but they don`t seem to actually test them with Linux or at least are not 
able to "support" Linux usage.......

Ridicuous!



> List:       linux-kernel
> Subject:    Western Digital GreenPower drives and Linux
> From:       "Tvrtko A. Ursulin" <tvrtko () ursulin ! net>
> Date:       2008-04-09 20:18:35
> Message-ID: 200804092118.35501.tvrtko () ursulin ! net
> [Download message RAW]
>
>
> Hi all,
>
> The subject may be a bit misleading since I haven't investigated the whole
> issue under other OS-es (nor do I plan to), but this is how the story 
> goes..
>
> Those fancy new WD GreenPower drives seem to be heavily suffering from the
> rapidly increasing head load/unload problem. And the bad thing is they 
> don't
> respond to 'hdparm -B', which would mean (I think) their power management
> behaviour is solely up to their firmware.
>
> I got one of them (WD5000AACS) recently and to my horror after less than 
> three
> days of being power on this is what I saw:
>
> 9 Power_On_Hours       0x0032 100 100 000 Old_age Always  - 66
> 193 Load_Cycle_Count 0x0032 197 197 000 Old_age  Always  - 10233
>
> At this rate the disk would reach it's design limit for load/unload cycles 
> in
> around 80 days. Not good - so I implemented a lame workaround of keeping 
> disk
> busy every couple of seconds - hopefully that won't kill it sooner that
> unloads would..
>
> I am also currently talking with first line of WD's tech support trying to 
> get
> some data on how exactly those drives manage head unloading, but that may 
> not
> lead anywhere useful.
>
> So in parallel I decided to ask here to see if someone knows something 
> about
> this?
>
> If it matters, I am running vanilla 2.6.24 on that box and sata_sil is 
> driving
> that disk. Otherwise it is a pretty basic Ubuntu 7.10, a mix of ext3 and 
> jfs
> filesystems, all mounted with noatime. More detailed information available 
> on
> request.
>
> Tvrtko
>
>
> 

