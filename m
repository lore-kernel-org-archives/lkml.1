Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbXGCRuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbXGCRuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbXGCRur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:50:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48907 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755408AbXGCRuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:50:46 -0400
Date: Tue, 3 Jul 2007 18:56:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jeff@garzik.org
Subject: Re: [PATCH] pata_hpt3x3: Major reworking and testing
Message-ID: <20070703185652.0b807fcc@the-village.bc.nu>
In-Reply-To: <200707031938.20956.bzolnier@gmail.com>
References: <20070703161002.1576c39d@the-village.bc.nu>
	<200707031938.20956.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The new improved driver is not really better than the old one because
> the old one is broken. :)
> 
> Old driver does identical configuration when it comes to PIO modes.

No the old driver doesn't even do that. It starts up. It spuriously
adjusts some non writable PCI BAR registers, prints a message about
resources being in use already then exits.

I had a poke around the setup. As far as I can observe we break even if
the ROM timing values are used as is. I suspect documentation or a good
deal of luck is needed.

Alan
