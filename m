Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbYG2AsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbYG2AsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYG2Arx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:47:53 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:57103 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbYG2Arw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:47:52 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: soft lockup while copying data from a FAT usb stick and consequent FAT table corruption
References: <488DC849.1050407@gmail.com>
Date: Tue, 29 Jul 2008 09:47:48 +0900
In-Reply-To: <488DC849.1050407@gmail.com> (Riccardo Magliocchetti's message of
	"Mon, 28 Jul 2008 15:23:21 +0200")
Message-ID: <871w1d1por.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com> writes:

> Jul 24 19:03:10 eurasia kernel: [25075.616150] sd 0:0:0:0: [sda] Assuming drive cache: write through
> Jul 24 19:03:10 eurasia kernel: [25075.616153]  sda: sda1
> Jul 24 19:03:10 eurasia kernel: [25075.617510] sd 0:0:0:0: [sda] Attached SCSI removable disk
> Jul 24 19:03:17 eurasia kernel: [25083.820927] usb 1-5: reset high speed USB device using ehci_hcd and address 2
> Jul 24 19:03:19 eurasia kernel: [25085.483682] usb 1-5: reset high speed USB device using ehci_hcd and address 2
> Jul 24 19:03:19 eurasia kernel: [25085.624466] sd 0:0:0:0: [sda] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
> Jul 24 19:03:19 eurasia kernel: [25085.624466] end_request: I/O error, dev sda, sector 37

It seems I/O error of device. Do this device work if without FAT?
E.g. read and write to device (/dev/xxx), etc.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
