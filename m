Return-Path: <linux-kernel-owner+w=401wt.eu-S1764185AbZLQJ2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764185AbZLQJ2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759054AbZLQJ2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:28:18 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:57361 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756716AbZLQJ2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:28:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19241.63911.160765.909812@pilspetsen.it.uu.se>
Date: Thu, 17 Dec 2009 10:28:07 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Romain Kubany <rkubany@ikoula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Possible regression of LBA48 support for piix
In-Reply-To: <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB2AF@HMCEXMBX01CLUS.hmcikoula.com>
References: <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB2AF@HMCEXMBX01CLUS.hmcikoula.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Romain Kubany writes:
 > Hello,
 > 
 > We are using Microsoft Hyper-V Virtualization technology for some of our GNU/Linux guests and we recently discovered 
 > that the emulated hardware does not seem to support LBA48 adressing on IDE controller.
 > 
 > After some tests, here are the results on a VM with a 200GB virtual disk : disk is detected as 214748MB up to kernel 2.6.27.41 and as 136899MB in 2.6.28 and up.
 > 
 > The two kernels (2.6.27.41 and 2.6.28) were compiled with approximatively the same parameters (just an oldconfig between them, I'll paste a line to their respective config at the end of the mail)
 > except that many changes occured in IDE management between 2.6.27 and 2.6.28 series of the kernel so it is possible that the problem is coming from a misconfiguration on our side (in which case I'll present you my truthful apologies for making you waste your time).
 > 
 > Here are some useful informations (I think) for start :
 > 
 > [On the "working" kernel, 2.6.27.41 w/ 200GB recognized vdisk]
 > 
 > # hdparm -I /dev/hda

Try using libata and ata_piix instead of the old IDE drivers, but
be aware that the disk will show up as /dev/sda not /dev/hda.

Also, IDE/ATA-related issues should be cc:d to linux-ide (see MAINTAINERS).
