Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYCaJ4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYCaJ4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbYCaJ4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:56:46 -0400
Received: from [81.2.110.250] ([81.2.110.250]:48328 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751713AbYCaJ4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:56:44 -0400
Date: Mon, 31 Mar 2008 10:37:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Michael Schmitz <schmitz@debian.org>
Subject: Re: [PATCH 5/5] falconide/q40ide: add ->atapi_*put_bytes and
 ->ata_*put_data methods
Message-ID: <20080331103713.47d715f7@core>
In-Reply-To: <Pine.LNX.4.64.0803310750230.6871@anakin>
References: <200803301714.04527.bzolnier@gmail.com>
	<Pine.LNX.4.64.0803302012560.16372@anakin>
	<200803302134.42569.bzolnier@gmail.com>
	<Pine.LNX.4.64.0803310750230.6871@anakin>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, the data on the disk is stored byte-swapped.
> So it's only the drive ID and packet commands that should be swapped.

If you are storing the data on disk byte swapped then reverse the logic
in the driver so you don't need hacks for un-swapping commands and write
a bytesewap device mapper layer in the right place. Then you can even
move disks around.

It's ugly because the solution is currently in the wrong place (for good
historical reasons this is true)

Alan
