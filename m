Return-Path: <linux-kernel-owner+w=401wt.eu-S2992438AbXCGSUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992438AbXCGSUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992443AbXCGSUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:20:48 -0500
Received: from nn7.de ([85.214.94.156]:43762 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992438AbXCGSUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:20:41 -0500
Subject: Re: Linux v2.6.21-rc3
From: Soeren Sonnenburg <kernel@nn7.de>
To: tglx@linutronix.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <1173277354.24738.620.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
	 <1173277354.24738.620.camel@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Mar 2007 18:42:47 +0100
Message-Id: <1173289367.4368.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 15:22 +0100, Thomas Gleixner wrote:
> On Tue, 2007-03-06 at 20:59 -0800, Linus Torvalds wrote:
> > We've finally hopefully started to put a dent in the regressions, 
> > especially the suspend/resume problems introduced since 2.6.20.
> 
> Still having SATA breakage on resume:
> 
> Caught that one (from screen)
> 
> ATA: abnormal status 0x7F on port 0x000118cf
> irq 21: nobody cared (try booting ......)
> ...
> Disabling IRQ #21
> 
> 
> During normal boot I see the "ATA: abnormal status 0x7F on port
> 0x000118cf" once, but there the system behaves normal
> 
> 	tglx

maybe that is also causing the hang I am still seeing with the full
config... :(
(no display, no usb device activation, but I tend to think the mbp wants
to access the hdd...)

SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
ata1: port is slow to respond, please be patient (Status 0x80)
ata1: port failed to respond (30 secs, Status 0x80)
ATA: abnormal status 0x80 on port 0x000101f7
ATA: abnormal status 0x80 on port 0x000101f7
ATA: abnormal status 0x80 on port 0x000101f7
ATA: abnormal status 0x80 on port 0x000101f7
ATA: abnormal status 0x80 on port 0x000101f7
ata1.00: qc timeout (cmd 0xa1)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1.00: revalidation failed (errno=-5)
ata1: failed to recover some devices, retrying in 5 secs
ata1: port is slow to respond, please be patient (Status 0x80)
ata1: port failed to respond (30 secs, Status 0x80)
ATA: abnormal status 0x80 on port 0x000101f7
ATA: abnormal status 0x80 on port 0x000101f7
ATA: abnormal status 0x80 on port 0x000101f7
ATA: abnormal status 0x80 on port 0x000101f7
ATA: abnormal status 0x80 on port 0x000101f7

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
