Return-Path: <linux-kernel-owner+w=401wt.eu-S932788AbXGYB3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbXGYB3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 21:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760863AbXGYB3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 21:29:22 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:47151 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758934AbXGYB3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 21:29:21 -0400
Date: Tue, 24 Jul 2007 21:29:07 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: v2.6.22.1-rt5
In-reply-to: <20070724191027.GA13268@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Message-id: <200707242129.07251.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070724120436.GA14466@elte.hu>
 <200707241156.03149.gene.heskett@gmail.com> <20070724191027.GA13268@elte.hu>
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2007, Ingo Molnar wrote:
>* Gene Heskett <gene.heskett@gmail.com> wrote:
>> The above stanza still needs some tlc.  I built a 2.6.22.1-rt6 (rt5
>> wouldn't build) using the same old config that a make oldconfig didn't
>> fuss about, but the reboot never completed, see the attached, heavily
>> smunched camera shot of the panic.
>>
>> Kinda looks like hda/sda confusion, with rt3 (this boot), its hda*,
>> what is it now?  fstab or kernel config error?
>
>yeah, as long as your filesystems are created with a proper label, all
>that you need to do is to change all 'hda' to 'sda' in the new kernel's
>/etc/grub.conf entry. (or enable the old IDE code in the .config, under
>CONFIG_IDE)
>
>	Ingo

Damn, I didn't say it clear enough, the / is on an LVM volume.  /Boot is 
on /dev/hda1, aka (hd0,0) in the first line.  Since the msg pointed at 0,0, 
I'll switch that line to "root (sd0,0)" just for grins.

I take it that was an auto-conversion?  I did nothing to confirm any changes 
when I ran a make oldconfig, using the 2.6.22.1-rt3 .config as the src 
config.

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
But I was there and I saw what you did,
I saw it with my own two eyes.
So you can wipe off that grin;
I know where you've been--
It's all been a pack of lies!
