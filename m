Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbYA1Rbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbYA1Rbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYA1Rb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:31:26 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:46162 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbYA1RbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:31:25 -0500
Date: Mon, 28 Jan 2008 12:30:32 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <1201540830.6526.19.camel@localhost>
To: Zan Lynx <zlynx@acm.org>
Cc: Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Message-id: <200801281230.32910.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <1201539043.31293.7.camel@zem> <1201540830.6526.19.camel@localhost>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Zan Lynx wrote:
>On Mon, 2008-01-28 at 11:50 -0500, Calvin Walton wrote:
>> On Mon, 2008-01-28 at 11:35 -0500, Gene Heskett wrote:
>> > On Monday 28 January 2008, Mikael Pettersson wrote:
>> > >Unfortunately we also see:
>> > > > [   48.285456] nvidia: module license 'NVIDIA' taints kernel.
>> > > > [   48.549725] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [APC4] ->
>> > > > GSI 19 (level, high) -> IRQ 20 [   48.550149] NVRM: loading NVIDIA
>> > > > UNIX x86 Kernel Module  169.07  Thu Dec 13 18:42:56 PST 2007
>> > >
>> > >We have no way of debugging that module, so please try 2.6.24 without
>> > > it.
>> >
>> > Sorry, I can't do this and have a working machine.  The nv driver has
>> > suffered bit rot or something since the FC2 days when it COULD run a 19"
>> > crt at 1600x1200, and will not drive this 20" wide screen lcd 1680x1050
>> > monitor at more than 800x600, which is absolutely butt ugly fuzzy,
>> > looking like a jpg compressed to 10%.  The system is not usable on a day
>> > to basis without the nvidia driver.
>>
>> You should probably give the nouveau[1] driver a try, if only for
>> testing purposes; if you are running an NV4x (G6x or G7x) card in
>> particular, it works a lot better than the nv driver for 2d support.
>>
>> 1. http://nouveau.freedesktop.org/wiki/InstallNouveau
>
>But nouveau is much less stable than nv.  For testing purposes, go with
>stable.
>
I believe at this point, its moot.  I captured quite a few instances of that 
error message while rebooting the last time, all of which occurred long 
before I logged in and did a startx (I boot to runlevel 3 here), so the 
kernel was NOT tainted at that point.  That dmesg has been posted and some 
questions asked.

As this has gone on for a while, it seems to me that with 14,800 google hits 
on this problem, Linus should call a halt until this is found and fixed.  But 
I'm not Linus.  I'm also locking up for 30 at a time, & probably ready for 
reboot #7 today.

>I'm not sure why it won't run his screen though.  I can use nv to run a
>1920x1200 laptop LCD.  It *is* dog slow (although nouveau was not any
>better with a NV17 / 440-Go -- render support for AA fonts seems to be
>missing), but it does work.



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
There cannot be a crisis next week.  My schedule is already full.
		-- Henry Kissinger
