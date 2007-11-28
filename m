Return-Path: <linux-kernel-owner+w=401wt.eu-S1760400AbXK1NVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760400AbXK1NVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 08:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757335AbXK1NVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 08:21:41 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47721 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757202AbXK1NVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:21:41 -0500
Date: Wed, 28 Nov 2007 13:18:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Julia Lawall <julia@diku.dk>
Cc: ambx1@neo.rr.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers/pnp/resource.c: Add missing pci_dev_put
Message-ID: <20071128131816.49e92fde@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0711190905100.19198@ask.diku.dk>
References: <Pine.LNX.4.64.0711190905100.19198@ask.diku.dk>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 09:07:22 +0100 (CET)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> There should be a pci_dev_put when breaking out of a loop that iterates
> over calls to pci_get_device and similar functions.


Entire series:

Acked-by: Alan Cox <alan@redhat.com>
