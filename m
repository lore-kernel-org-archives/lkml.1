Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbXEDOag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbXEDOag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbXEDOag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:30:36 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:46205 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354AbXEDOaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:30:35 -0400
Date: Fri, 4 May 2007 16:30:18 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Salvatore De Paolis <depaolis.salvatore@libero.it>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel parameters: root
In-Reply-To: <20070504153701.43123c02@debian>
Message-ID: <Pine.LNX.4.61.0705041628400.18504@yvahk01.tjqt.qr>
References: <20070504153701.43123c02@debian>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4 2007 15:37, Salvatore De Paolis wrote:
>
>I hope this is the right place to ask this question, if not please redirect me
>to the right ML.
>
>I would like to know more about kernel parameters and in particular about the
>root parameter.
>I'm booting the kernel from usb pen and the root could change while the pen is
>plugged in different machines with different hardware.
>I was trying to find info about "how to make this unique". 

By using root=/dev/disk/by-id/scsi-SATA_iCreate_CF_Card000000001-part1
for example. Requires an initramfs with udev.

>Does the kernel see only /dev/* ? There's no way to pass /dev/disk/*?

The kernel has special logic to translate some (not ALL)
/dev/[hs]d[abcd..] into device numbers if it cannot find
a device node.


Jan
-- 
