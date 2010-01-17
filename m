Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090Ab0AQINs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab0AQINs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 03:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655Ab0AQINr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 03:13:47 -0500
Received: from senator.holtmann.net ([87.106.208.187]:50680 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab0AQINr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 03:13:47 -0500
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial
 writes" causes gobi_loader to hang
From: Marcel Holtmann <marcel@holtmann.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: dvomlehn@cisco.com, gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100117025535.GB7045@srcf.ucam.org>
References: <20100117025535.GB7045@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Jan 2010 00:13:33 -0800
Message-ID: <1263716013.5591.55.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

> gobi_loader writes firmware to gobi USB devices (qcserial) via the USB 
> serial layer by writing it a megabyte at a time (matching the Windows 
> driver behaviour). Commit 8e8dce065088833fc418bfa5fbf035cb0726c04c 
> breaks it - strace shows the write simply hanging. ssyrq-t says the 
> backtrace is:
> 
> Jan 17 15:37:37 localhost kernel: Call Trace:
> Jan 17 15:37:37 localhost kernel: [<ffffffff8128986c>] n_tty_write+0x2da/0x351
> Jan 17 15:37:37 localhost kernel: [<ffffffff810464b4>] ? default_wake_function+0x0/0x14
> Jan 17 15:37:37 localhost kernel: [<ffffffff81286969>] tty_write+0x19d/0x245
> Jan 17 15:37:37 localhost kernel: [<ffffffff81289592>] ? n_tty_write+0x0/0x351
> Jan 17 15:37:37 localhost kernel: [<ffffffff81103e44>] vfs_write+0xae/0x10b
> Jan 17 15:37:37 localhost kernel: [<ffffffff81103f61>] sys_write+0x4a/0x6e
> Jan 17 15:37:37 localhost kernel: [<ffffffff81009e45>] tracesys+0xd9/0xde
> 
> The commit before this works fine.

maybe I should have finished my libusb version of the gobi_loader ;)

Regards

Marcel


