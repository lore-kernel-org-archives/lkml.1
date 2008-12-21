Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbYLUOtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbYLUOtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 09:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYLUOtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 09:49:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48008 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752219AbYLUOtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 09:49:08 -0500
Date: Sun, 21 Dec 2008 14:49:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: linux ext3 partition hosed, is this hardware of software error?
Message-ID: <20081221144913.76ca53d3@lxorguk.ukuu.org.uk>
In-Reply-To: <20081221143640.GF1509@gamma.logic.tuwien.ac.at>
References: <20081221143640.GF1509@gamma.logic.tuwien.ac.at>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>          res 41/40:40:38:3d:95/91:00:0a:00:00/6a Emask 0x409 (media error) <F>
> ata1.00: status: { DRDY ERR }
> ata1.00: error: { UNC }

Bad sectors

> Buffer I/O error on device sda3, logical block 12
> Buffer I/O error on device sda3, logical block 13

Right near the start of the disk.

Make a copy of the partition with a recovery tool and write it somewhere
(file on another disk whatever) and keep it safe. Make a copy of that and
fsck the copy. You may need to use the alternate superblock option on
fsck for this.

Alan
