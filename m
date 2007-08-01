Return-Path: <linux-kernel-owner+w=401wt.eu-S1762796AbXHAAKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762796AbXHAAKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbXHAAJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:09:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55917 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756019AbXHAAJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:09:57 -0400
Date: Wed, 1 Aug 2007 01:16:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, khc@pm.waw.pl
Subject: Re: [PATCH 55] drivers/char/n_hdlc.c: kmalloc + memset conversion
 to kzalloc
Message-ID: <20070801011655.08e3c17b@the-village.bc.nu>
In-Reply-To: <200707312327.30692.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200707312327.30692.m.kozlowski@tuxland.pl>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 23:27:30 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

NAK

> -	struct n_hdlc *n_hdlc = kmalloc(sizeof(*n_hdlc), GFP_KERNEL);
> -
> +	struct n_hdlc *n_hdlc;
> +
> +	n_hdlc = kzalloc(sizeof(*n_hdlc), GFP_KERNEL);

Change looks fine but please keep the original formatting style
