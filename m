Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251Ab0AGAgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab0AGAgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192Ab0AGAgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:36:43 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:48213 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab0AGAgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:36:42 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: Linux 2.6.33-rc3, rc2 regression at boot
Date: Wed, 06 Jan 2010 19:36:10 -0500
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3; KDE/4.3.3; i686; ; )
References: <alpine.LFD.2.00.1001051838410.3630@localhost.localdomain>
 <201001061602.44133.gene.heskett@verizon.net>
 <alpine.LRH.2.00.1001070053390.15694@twin.jikos.cz>
In-reply-to: <alpine.LRH.2.00.1001070053390.15694@twin.jikos.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Message-id: <201001061936.10315.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 January 2010, Jiri Kosina wrote:
>On Wed, 6 Jan 2010, Gene Heskett wrote:
>> >[    0.558368] Unpacking initramfs...
>> >[    0.648644] Freeing initrd memory: 3431k freed
>> >[    0.651635] platform microcode: firmware: requesting
>> > amd-ucode/microcode_amd.bin [   60.646738] microcode: failed to load
>> > file amd-ucode/microcode_amd.bin [   60.646858] microcode: CPU0:
>> > patch_level=0x1000065
>> >[   60.646977] microcode: CPU1: patch_level=0x1000065
>> >[   60.647099] microcode: CPU2: patch_level=0x1000065
>> >[   60.647218] microcode: CPU3: patch_level=0x1000065
>> >
>> >Note the time, it kills quite close to a whole minute there, which at
>> > first would appear to be because there is not yet a mounted /lib
>> > filesystem to suck it from.  I didn't build an rc1, but rc2 also
>> > suffers from this. 2.6.32.2 does not do this although its firmware
>> > request takes place at the same point. So it doesn't look like it is
>> > the lack of a mounted filesystem after all.
>> >
>> >FWIW, because it was a hot reboot, the patch_level reported is the
>> > correct level.
>> >
>> >I am also seeing some complaints about my Audigy2 sound card, but what I
>> > saw during the boot, never made it to the messages log.  Something
>> > about guessing at the proper config, but I did hear kde sign on when x
>> > started.
>> >
>> >Thanks Linus.
>>
>> Update, I edited the .config by hand and added the full path in
>> CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware/"
>> which was just 'firmware', and rebuilt.  No difference.  I still get the
>> 60 second hang.  FWIW, this particular setting isn't visible in a make
>> xconfig.
>
>As this is already at the stage when userspace exists and init has been
>started, it might well be delay of some userspace stuff, not directly
>kernel.
>
>Does alt-sysrq-t at the time it is stuck give any clue?
>
I will try that when I next reboot, thanks Jiri

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)

"Just the facts, Ma'am"
-- Joe Friday
