Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbXE0MNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbXE0MNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 08:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXE0MNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 08:13:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55733 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300AbXE0MNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 08:13:14 -0400
Date: Sun, 27 May 2007 13:18:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add Marvell 6141 PATA support to AHCI driver
Message-ID: <20070527131807.46b81b8d@the-village.bc.nu>
In-Reply-To: <20070527030954.GA18974@havoc.gtf.org>
References: <20070527030954.GA18974@havoc.gtf.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Engineering questions I need to bounce back to Marvell:
> * do I need to worry about PIO/UDMA timing?  I don't see any registers
>   or other knobs dealing with timing.  Maybe the controller snoops?

In non-AHCI mode it certainly seems to do the snooping for you

Acked-by: Alan Cox <alan@redhat.com>

Alan

