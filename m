Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbYBERx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbYBERx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbYBERxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:53:41 -0500
Received: from mail.dbd-breitband.de ([217.188.211.21]:8931 "EHLO
	dbd-mpx01.dbd-breitband.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754913AbYBERxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:53:37 -0500
From: Marc Donner <donner@dbd-breitband.de>
Organization: DBD DeutscheBreitbandDienste
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: dma error on boot with cf card
Date: Tue, 5 Feb 2008 18:52:29 +0100
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051852.29592.donner@dbd-breitband.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

i have a problem using a cf card with an ide adapter. 
using debian kernel 2.6.18-5 

on boot:
Feb  5 17:38:06 kernel: hdd: max request size: 128KiB
Feb  5 17:38:06 kernel: hdd: 2000880 sectors (1024 MB) w/2KiB Cache, 
CHS=1985/16/63, UDMA(33)
Feb  5 17:38:06 kernel:  hdd:<4>hdd: dma_timer_expiry: dma status == 0x41
Feb  5 17:38:06 kernel: hdd: DMA timeout error
Feb  5 17:38:06 kernel: hdd: dma timeout error: status=0x58 { DriveReady 
SeekComplete DataRequest }
Feb  5 17:38:06 kernel: ide: failed opcode was: unknown
Feb  5 17:38:06 kernel: hdd: irq timeout: status=0xd0 { Busy }
Feb  5 17:38:06 kernel: ide: failed opcode was: unknown
Feb  5 17:38:06 kernel: ide1: reset timed-out, status=0xff
Feb  5 17:38:06 kernel: hdd: status timeout: status=0xff { Busy }
Feb  5 17:38:06 kernel: ide: failed opcode was: unknown
Feb  5 17:38:06 kernel: hdd: drive not ready for command
Feb  5 17:38:06 kernel: ide1: reset timed-out, status=0xff
Feb  5 17:38:06 kernel: end_request: I/O error, dev hdd, sector 0
Feb  5 17:38:06 kernel: Buffer I/O error on device hdd, logical block 0
Feb  5 17:38:06 kernel: end_request: I/O error, dev hdd, sector 0
Feb  5 17:38:06 kernel: Buffer I/O error on device hdd, logical block 0
Feb  5 17:38:06 kernel:  unable to read partition table
Feb  5 17:38:06 kernel: end_request: I/O error, dev hdd, sector 2000640
Feb  5 17:38:06 kernel: Buffer I/O error on device hdd, logical block 250080
Feb  5 17:38:06 kernel: end_request: I/O error, dev hdd, sector 2000640


any ideas?

regards
Marc
