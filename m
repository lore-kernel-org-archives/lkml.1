Return-Path: <linux-kernel-owner+w=401wt.eu-S932202AbXJQKqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbXJQKqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 06:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757703AbXJQKpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 06:45:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35764 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756741AbXJQKpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 06:45:54 -0400
Date: Wed, 17 Oct 2007 11:49:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luming Yu" <luming.yu@gmail.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC patch] fallback to "no irq" hack for case of no pnp_irq
 allocated for 8250_pnp
Message-ID: <20071017114937.0a646f27@the-village.bc.nu>
In-Reply-To: <3877989d0710161950n3d255330lf55e190dde628277@mail.gmail.com>
References: <3877989d0710161950n3d255330lf55e190dde628277@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Yu Luming <luming.yu@intel.com>
> 
>  8250_pnp.c |    3 +++
>  1 files changed, 3 insertions(+)

Should really fix pnp_irq() to use zero to mean none as the kernel
intends. If that causes other complications then this hack will do for
now I guess.

Alan
