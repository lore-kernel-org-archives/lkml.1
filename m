Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbXJKV2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbXJKV2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbXJKV15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:27:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35736 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755235AbXJKV14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:27:56 -0400
Date: Thu, 11 Oct 2007 22:32:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: struct pci_dev cleanups
Message-ID: <20071011223228.2b472707@the-village.bc.nu>
In-Reply-To: <20071011211317.GA30328@havoc.gtf.org>
References: <20071011211317.GA30328@havoc.gtf.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>     * pata_cs5520: delete cs5520_remove_one(), it was a duplicate of
>       ata_pci_remove_one()

Acked-by: Alan Cox <alan@redhat.com>

Now that pci_remove_one() doesn't go doing disable_device thats sensible.

Alan
