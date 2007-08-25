Return-Path: <linux-kernel-owner+w=401wt.eu-S934425AbXHYWWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934425AbXHYWWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 18:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbXHYWWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 18:22:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43553 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbXHYWV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 18:21:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46D0AB7B.1080709@s5r6.in-berlin.de>
Date: Sun, 26 Aug 2007 00:21:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Josh Boyer <jwboyer@gmail.com>, Casey Dahlin <cjdahlin@ncsu.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: USB Key light on/off state depending on mount
References: <46CF468E.1080607@ncsu.edu> <625fc13d0708241413s1086527id377b49e7adacc5e@mail.gmail.com> <Pine.LNX.4.60.0708252116580.3809@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0708252116580.3809@poirot.grange>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> I might imagine how windows turns the LED off on 
> unmount. Try "eject /dev/sdX", where sdX is your USB storage, after you 
> unmount it. Be careful, especially if you have SATA (or SCSI) discs in 
> your system or if you use libata for PATA discs not to eject the wrong 
> one...

If there is only one USB disk connected:
# eject /dev/disk/by-path/*usb*:0

Provided you let udev create links for you.  BTW, the /dev/disk/by-id/
symlinks are nice for static mount points in /etc/fstab.

After a disk was mounted, eject also accepts the mountpoint as parameter
and will unmount the disk before it tries to eject it.
-- 
Stefan Richter
-=====-=-=== =--- ==-=-
http://arcgraph.de/sr/
