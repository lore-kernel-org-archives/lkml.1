Return-Path: <linux-kernel-owner+w=401wt.eu-S934253AbXEMP7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934253AbXEMP7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 11:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758352AbXEMP7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 11:59:09 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:36984 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756374AbXEMP7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 11:59:08 -0400
Date: Sun, 13 May 2007 17:58:48 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
In-Reply-To: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0705131757320.9570@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 13 2007 11:22, Robert P. J. Day wrote:
>
>  not a big deal, but is there a reason that a "make defconfig" on my
>x86 system ends up selecting and building a single module?
>
>  Building modules, stage 2.
>  MODPOST 1 modules
>  CC      drivers/scsi/scsi_wait_scan.mod.o
>  LD [M]  drivers/scsi/scsi_wait_scan.ko
>
>is there something special about that module?  just curious.

$ make defconfig;
$ grep =m .config;
CONFIG_SCSI_WAIT_SCAN=m
$ grep -A2 SCSI_WAIT_SCAN drivers/scsi/Kconfig;
config SCSI_WAIT_SCAN
        tristate
        default m
$ grep SCSI_WAIT_SCAN arch/i386/Kconfig || echo "no result";
no result



	Jan
-- 
