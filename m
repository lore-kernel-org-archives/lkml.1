Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbZGETaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbZGETaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 15:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZGETaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 15:30:12 -0400
Received: from hera.cwi.nl ([192.16.191.8]:45849 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbZGETaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 15:30:11 -0400
Date: Sun, 5 Jul 2009 21:28:42 +0200
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, axboe@kernel.dk,
       Andries.Brouwer@cwi.nl, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc0: sdb1 only starts to exist when sdb is accessed?
Message-ID: <20090705192841.GA18151@ub>
References: <20090705185447.GA18498@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705185447.GA18498@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 08:54:47PM +0200, Pavel Machek wrote:
> 
> ...happens with android phone doing usb storage emulation. I'm using
> static /dev/ ... I hope!
> 
> Jul  5 20:06:02 amd udevd-event[17666]: mknod(/dev/bus/usb/001/073, 020664, (189,72) failed: Operation not permitted 
> Jul  5 20:06:07 amd kernel: scsi 24:0:0:0: Direct-Access     HTC      Android Phone    0100 PQ: 0 ANSI: 2
> Jul  5 20:06:07 amd kernel: sd 24:0:0:0: Attached scsi generic sg1 type 0
> Jul  5 20:06:07 amd kernel: sd 24:0:0:0: [sdb] Attached SCSI removable disk
> Jul  5 20:13:08 amd pand[17815]: Bluetooth PAN daemon version 3.36
> ...
> Jul  5 20:51:02 amd kernel: sd 24:0:0:0: [sdb] 3862528 512-byte hardware sectors: (1.97 GB/1.84 GiB)
> Jul  5 20:51:02 amd kernel: sd 24:0:0:0: [sdb] Assuming drive cache: write through
> Jul  5 20:51:02 amd kernel: sd 24:0:0:0: [sdb] Assuming drive cache: write through
> Jul  5 20:51:02 amd kernel:  sdb: sdb1
> 
> You see? Partitions are only detected long after device is
> detected. IIRC it did not behave like that before...

Hi Pavel,

This doesn't seem to have anything to do with partition detection:
the partition line has the same time stamp as the scsi identify line
("3862528 512-byte hardware sectors").

Andries

