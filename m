Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZGESzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZGESzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 14:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZGESy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 14:54:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44997 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZGESy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 14:54:57 -0400
Date: Sun, 5 Jul 2009 20:54:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: axboe@kernel.dk, aeb@cwi.nl, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.31-rc0: sdb1 only starts to exist when sdb is accessed?
Message-ID: <20090705185447.GA18498@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


...happens with android phone doing usb storage emulation. I'm using
static /dev/ ... I hope!

Jul  5 20:06:02 amd udevd-event[17666]: mknod(/dev/bus/usb/001/073, 020664, (189,72) failed: Operation not permitted 
Jul  5 20:06:07 amd kernel: scsi 24:0:0:0: Direct-Access     HTC      Android Phone    0100 PQ: 0 ANSI: 2
Jul  5 20:06:07 amd kernel: sd 24:0:0:0: Attached scsi generic sg1 type 0
Jul  5 20:06:07 amd kernel: sd 24:0:0:0: [sdb] Attached SCSI removable disk
Jul  5 20:13:08 amd pand[17815]: Bluetooth PAN daemon version 3.36
...
Jul  5 20:51:02 amd kernel: sd 24:0:0:0: [sdb] 3862528 512-byte hardware sectors: (1.97 GB/1.84 GiB)
Jul  5 20:51:02 amd kernel: sd 24:0:0:0: [sdb] Assuming drive cache: write through
Jul  5 20:51:02 amd kernel: sd 24:0:0:0: [sdb] Assuming drive cache: write through
Jul  5 20:51:02 amd kernel:  sdb: sdb1

You see? Partitions are only detected long after device is
detected. IIRC it did not behave like that before...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
