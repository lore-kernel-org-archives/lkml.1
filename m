Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbXJNMSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbXJNMSP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 08:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbXJNMR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 08:17:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57330 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754190AbXJNMRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 08:17:54 -0400
Date: Sun, 14 Oct 2007 13:21:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [git patches] libata update
Message-ID: <20071014132157.5646ac17@the-village.bc.nu>
In-Reply-To: <64bb37e0710140335g648a86ebmebdf32a6068abcf8@mail.gmail.com>
References: <20071012194002.GA1545@havoc.gtf.org>
	<64bb37e0710140335g648a86ebmebdf32a6068abcf8@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index
> (0FFFFFFFF) is beyond end of object [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.PCI0.IDE0.GTM_] (Node ffff810100318a20), AE_AML_PACKAGE_LIMIT
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.PCI0.IDE0.CHN0._GTM] (Node ffff8101003187c0),
> AE_AML_PACKAGE_LIMIT
> ata9: ACPI get timing mode failed (AE 0x300d)

Looks like an ACPI BIOS problem. In that situation we'll just give up on
using ACPI information

Not much else we can do as Nvidia don't document how to do a reliable
40/80 wire test and just told us to use the BIOS.
