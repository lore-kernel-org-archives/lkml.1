Return-Path: <linux-kernel-owner+w=401wt.eu-S1764100AbXHCVrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764100AbXHCVrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 17:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763061AbXHCVrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 17:47:06 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56853 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759505AbXHCVrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 17:47:05 -0400
Date: Fri, 3 Aug 2007 22:54:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH -mm] libata: add human-readable error value decoding v3
Message-ID: <20070803225408.658de171@the-village.bc.nu>
In-Reply-To: <46B36D59.7060803@shaw.ca>
References: <46B36D59.7060803@shaw.ca>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Aug 2007 12:00:57 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> This adds human-readable decoding of the ATA status and error registers
> (similar to what drivers/ide does) as well as the SATA Serror register to
> libata error handling output.  This prevents the need to pore through
> standards documents to figure out the meaning of the bits in these
> registers when looking at error reports.  Some bits that drivers/ide
> decoded are not decoded here, since the bits are either command-dependent
> or obsolete, and properly parsing them would add too much complexity.

Not sure its really worth it. Does "ABRT IDNF" actually tell you any more
than the hex code ? In fact I find the hex code clearer because its
usually the combination of state (0x51) etc that tells the story.

No objection to it going in and on a correctness basis

Acked-by: Alan Cox <alan@redhat.com>
