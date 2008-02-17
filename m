Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbYBQWlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbYBQWlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 17:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYBQWlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 17:41:07 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49773 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753967AbYBQWlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 17:41:04 -0500
Date: Sun, 17 Feb 2008 22:32:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] libata: implement support for 32-bit PIO transfers
Message-ID: <20080217223239.1f04e095@core>
In-Reply-To: <20080217212004.GB15327@1wt.eu>
References: <20080217211810.GA15001@1wt.eu>
	<20080217212004.GB15327@1wt.eu>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 22:20:04 +0100
Willy Tarreau <w@1wt.eu> wrote:

> 
> >From 4ea313fe6a3c46a90226cf40d0e3ece4b36b48f9 Mon Sep 17 00:00:00 2001
> From: Willy Tarreau <w@1wt.eu>
> Date: Sun, 17 Feb 2008 21:28:25 +0100
> Subject: [PATCH 2/2] libata: implement support for 32-bit PIO transfers
> 
> When ATA_DFLAG_32BIT_PIO is set in ata flags, PIO transfers
> will be performed in 32-bit, just like with the plain old IDE
> drivers.

Acked-by: Alan Cox <alan@redhat.com>

Although I think ata_data_xfer_32() would be safer and easier to add to
controllers as we check the docs. But that can be a follow up improvement.

Alan
