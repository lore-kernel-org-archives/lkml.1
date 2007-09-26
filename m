Return-Path: <linux-kernel-owner+w=401wt.eu-S1762579AbXIZOcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762579AbXIZOcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760937AbXIZOY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:24:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52685 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758443AbXIZOY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:24:26 -0400
Date: Wed, 26 Sep 2007 15:30:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Peer Chen <peerchen@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ahci: enable GHC.AE bit before set GHC.HR
Message-ID: <20070926153028.6fc5b2ce@the-village.bc.nu>
In-Reply-To: <46FA4587.4070105@garzik.org>
References: <200709211327569648280@gmail.com>
	<46F9DA07.4080201@garzik.org>
	<20070926122332.39351382@the-village.bc.nu>
	<46FA4587.4070105@garzik.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > NAK - mmio is an iomap so writel and readl are the wrong things to use
> 
> The patch is consistent with the rest of the driver.
> You are welcome to submit a patch to convert ahci to using ioremap.

You could just flip the relevant function to use ioread while you are
tidying it up, instead of spreading new bugs into the code.

Alan
