Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559Ab0AQJOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab0AQJOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 04:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317Ab0AQJOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 04:14:05 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:39834 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0AQJOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 04:14:01 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Sun, 17 Jan 2010 10:14:44 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: dvomlehn@cisco.com, gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <20100117025535.GB7045@srcf.ucam.org>
In-Reply-To: <20100117025535.GB7045@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001171014.44403.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 17. Januar 2010 03:55:35 schrieb Matthew Garrett:
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

Hi,

please load usbserial with debug=1 and post the output of just before the hang.

	Regards
		Oliver
