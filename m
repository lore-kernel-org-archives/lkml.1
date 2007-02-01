Return-Path: <linux-kernel-owner+w=401wt.eu-S1751799AbXBAPsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbXBAPsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXBAPsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:48:17 -0500
Received: from chicken.visionpro.com ([63.91.95.13]:22640 "EHLO
	chicken.machinevisionproducts.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751799AbXBAPsQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:48:16 -0500
X-Ninja-PIM: Scanned by Ninja
X-Ninja-AttachmentFiltering: (no action)
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.16.16 Lost CD-ROM Drive
Date: Thu, 1 Feb 2007 07:48:10 -0800
Message-ID: <14CFC56C96D8554AA0B8969DB825FEA001C3A234@chicken.machinevisionproducts.com>
Thread-Topic: 2.6.16.16 Lost CD-ROM Drive
thread-index: AcdGEmfqKNQXvUS9QUKu26s0psRJ6AABeJeA
From: "Brian D. McGrew" <brian@visionpro.com>
To: <jeremy@emperorlinux.com>
Cc: <linux-precision@dell.com>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Jeremy L. Moles [mailto:jeremy@emperorlinux.com] 
Sent: Thursday, February 01, 2007 7:05 AM
To: Brian D. McGrew
Cc: linux-precision@dell.com; linux-kernel@vger.kernel.org
Subject: Re: 2.6.16.16 Lost CD-ROM Drive

On Thu, 2007-02-01 at 07:00 -0800, Brian D. McGrew wrote:
> Hey guys-
> 
> Have a Precision workstation with SATA hard drive and SATA CD-ROM.  If
I
> load Fedora Core 5 with a stock 2.6.15 kernel, life is good.
> 
> However, I need to use 2.6.16.16.  Once I build and install this
kernel,
> my CD-ROM drive is gone.  There is a log entry in dmesg that says
"ATAPI
> not support.  Ignoring."  
> 
> If I go into the BIOS and set the SATA operations to Legacy/Compatible
> then everything is fine.  I've rebuilt this kernel about 100 times
> trying everything I can think of.
> 
> When I have SATA set to legacy, the HDD and CD are detected as
/dev/hd*
> and when they're set to SATA Normal operation the HDD is detected as
> /dev/sda.  If I boot my old 2.6.15 (stock install) kernel then the CD
is
> found as /dev/sdc.  
> 
> I've even tried taking the installation default configuration file for
> the 2.6.15 kernel and just wholesale copying it into my 2.6.16.16
kernel
> and build that way but still no go.
> 
> What am I missing to get the 2.6.16.16 kernel to see a SATA CD-ROM
drive
> in normal, non-legacy move?

Try booting 2.6.16 with the following options:

libata.atapi_enabled=1 ide0=noprobe ide1=noprobe
-----

Still no go.  /dev/sda* is created for the hard drive but no CD-ROM and
the same ATAPI error in dmesg.

-brian
