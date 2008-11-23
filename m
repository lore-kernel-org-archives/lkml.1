Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYKWSOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYKWSOt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 13:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYKWSOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 13:14:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39226 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbYKWSOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 13:14:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Fabio Comolli" <fabio.comolli@gmail.com>
Subject: Re: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Date: Sun, 23 Nov 2008 19:14:09 +0100
User-Agent: KMail/1.9.9
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com>
In-Reply-To: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811231914.09982.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 of November 2008, Fabio Comolli wrote:
> Hi.
> As the subject says, I have a strange regression in latest git.
> Sometimes resume from hibernating hangs _after_ the resume stage.
> When the problem happens I usually have to powercycle my laptop.
> 
> The system managed to recover from the hang only twice and this time I
> found in the logs:
> 
> Nov 23 16:43:14 hawking kernel: sd 0:0:0:0: [sda] Starting disk
> Nov 23 16:43:14 hawking kernel: Restarting tasks ... done.
> Nov 23 16:43:52 hawking kernel: ata1.01: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x6 frozen
> Nov 23 16:43:52 hawking kernel: ata1.01: cmd
> a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0
> Nov 23 16:43:52 hawking kernel:          cdb 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00
> Nov 23 16:43:52 hawking kernel:          res
> 40/00:03:00:00:00/00:00:00:00:00/b0 Emask 0x4 (timeout)
> Nov 23 16:43:52 hawking kernel: ata1.01: status: { DRDY }
> Nov 23 16:43:52 hawking kernel: ata1: soft resetting link
> Nov 23 16:43:57 hawking kernel: ata1.01: qc timeout (cmd 0xa1)
> Nov 23 16:43:57 hawking kernel: ata1.01: failed to IDENTIFY (I/O
> error, err_mask=0x4)
> Nov 23 16:43:57 hawking kernel: ata1.01: revalidation failed (errno=-5)
> Nov 23 16:43:57 hawking kernel: ata1: soft resetting link
> Nov 23 16:44:08 hawking kernel: ata1.01: qc timeout (cmd 0xa1)
> Nov 23 16:44:08 hawking kernel: ata1.01: failed to IDENTIFY (I/O
> error, err_mask=0x4)
> Nov 23 16:44:08 hawking kernel: ata1.01: revalidation failed (errno=-5)
> Nov 23 16:44:08 hawking kernel: ata1: soft resetting link
> Nov 23 16:44:38 hawking kernel: ata1.00: configured for UDMA/100
> Nov 23 16:44:38 hawking kernel: ata1.01: configured for MWDMA2
> Nov 23 16:44:38 hawking kernel: ata1: EH complete
> Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] 156301488 512-byte
> hardware sectors: (80.0 GB/74.5 GiB)
> Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] Write Protect is off
> Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] Write cache:
> enabled, read cache: enabled, doesn't support DPO or FUA
> Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] 156301488 512-byte
> hardware sectors: (80.0 GB/74.5 GiB)
> Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] Write Protect is off
> Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] Write cache:
> enabled, read cache: enabled, doesn't support DPO or FUA
> 
> This problem:
> 
> * never happened in 2.6.27.4
> * happened many times in 2.6.27.5 and .6
> * never happened in 2.6.27.7

Please test 2.6.27.7 a bit more.  It would be helpful to verify it's OK.

> * happened the first time with the current -rc series just now (the
> logs are related to this one)
> 
> This is the first 2.6.28-rc kernel I tried.

Do you mean 2.6.28-rc6?

Rafael
