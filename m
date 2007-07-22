Return-Path: <linux-kernel-owner+w=401wt.eu-S1764008AbXGVUcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764008AbXGVUcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 16:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764266AbXGVUcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 16:32:00 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33025 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763415AbXGVUbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 16:31:55 -0400
Date: Sun, 22 Jul 2007 21:38:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: Bartek <poemann@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Pata support for IDE Controller 82801G ICH7 in Linux 2.6.22
Message-ID: <20070722213844.6a1656c3@the-village.bc.nu>
In-Reply-To: <6bffcb0e0707221155l5bf7702r449846be48940a42@mail.gmail.com>
References: <19061b0b0707220259h207f27d7wa836b1973c547e63@mail.gmail.com>
	<6bffcb0e0707220311v5b145050hbd911e37b6f14c80@mail.gmail.com>
	<19061b0b0707221021p4ca776d9k737121ddf553b1ce@mail.gmail.com>
	<6bffcb0e0707221155l5bf7702r449846be48940a42@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 00:1f.1 0101: 8086:27df (rev 02)
> 
> Ok, this controller is supported.
> Did you forgot about CONFIG_PATA_MPIIX=y?

MPIIX is for early Intel laptop (pentium era).

If the chip is in AHCI mode then CONFIG_AHCI may be what is missing 
