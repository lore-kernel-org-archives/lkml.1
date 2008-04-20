Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbYDTD2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbYDTD2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 23:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYDTD2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 23:28:10 -0400
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:54488 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbYDTD2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 23:28:09 -0400
Message-ID: <480AB847.9010708@blueyonder.co.uk>
Date: Sun, 20 Apr 2008 04:28:07 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 3.0a1pre (X11/2007120104)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-git1/2 not seeing /dev/sda1 (XFS root) or /dev/sda2 (swap)
 partitions on a SATA drive
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <480A9C1E.8050505@xxxxxxxxxxxxxxxx> you wrote:
 >> 2.6.25 x86_64 boots fine as does -git1/2 boxes using reiserfs and ext3.
 >> With xfs it can't find these and drops into a shell.

 > Do you have reiser and ext3 as modules as well? If yes, how do you 
load them
 > (i.e. which distribution, bootload and initram you are using?)

 > Gruss
 > Bernd
Distro is openSUSE 11.0 Beta1 on all boxes, only one with xfs.
I have reiserfs, jfs, ext3 and xfs all as modules, loaded by mkinitrd.
Kernel image:   /boot/2.6.25-git2-smp
Initrd image:   /boot/initrd2.6.25-git2-smp
Root device: 
/dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part1 
(/dev/sda1) (mounted on / as xfs)
Resume device:  /dev/sda2
Kernel Modules: processor thermal dock scsi_mod libata sata_sil24 
sata_nv pata_amd fan xfs edd sd_mod usbcore ohci-hcd uhci-hcd ehci-hcd 
ff-memless hid usbhid
Features:       block usb resume.userspace resume.kernel
Bootsplash:     openSUSE (1024x768)
73057 blocks

 From /boot/grub/menu.lst
# Modified by YaST2. Last modification on Sat Apr 19 23:11:11 BST 2008
default 2
timeout 8
##YaST - generic_mbr
gfxmenu (hd0,0)/boot/message

###Don't change this comment - YaST2 identifier: Original name: 
linux-git2-smp###
title 2.6.25-git2-smp
     root (hd0,0)
     kernel /boot/2.6.25-git2-smp 
root=/dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part1 
vga=0x31a resume=/dev/sda2 splash=silent showopts elevator=cfq
     initrd /boot/initrd2.6.25-git2-smp
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

