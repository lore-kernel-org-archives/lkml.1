Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbXGGT4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbXGGT4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 15:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbXGGT4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 15:56:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57080 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753102AbXGGT4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 15:56:38 -0400
Date: Sat, 7 Jul 2007 21:02:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, Vitaly Bordug <vitb@kernel.crashing.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [ide] mmio ide support
Message-ID: <20070707210234.6aed88bb@the-village.bc.nu>
In-Reply-To: <200707071419.52650.arnd@arndb.de>
References: <20070707094852.9473.21013.stgit@localhost.localdomain>
	<200707071419.52650.arnd@arndb.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You could also make it an of_platform_driver at the same time
> instead of adding more cruft to fsl_soc.c. Since we're already
> about to add the electra_ide.c driver in 2.6.23, I guess there
> should really be _one_ driver that is able to handle all
> of_device based ATA hosts.

and do so using libata. Preferably ata_platform but it does look like
ata_of would make sense as a companion.

Alan
