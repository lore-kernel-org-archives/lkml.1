Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbXKHKwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbXKHKwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 05:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758467AbXKHKwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 05:52:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46905 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753636AbXKHKwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:52:34 -0500
Date: Thu, 8 Nov 2007 10:52:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH 1/2 take #2] libata: Support PIO polling-only hosts.
Message-ID: <20071108105235.636accd4@the-village.bc.nu>
In-Reply-To: <20071108021456.GA30648@linux-sh.org>
References: <20071108021456.GA30648@linux-sh.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007 11:14:56 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> By default ata_host_activate() expects a valid IRQ in order to
> successfully register the host. This patch enables a special case
> for registering polling-only hosts that either don't have IRQs
> or have buggy IRQ generation (either in terms of handling or
> sensing), which otherwise work fine.
> 
> Hosts that want to use polling mode can simply set ATA_FLAG_PIO_POLLING
> and pass in an invalid IRQ.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Acked-by: Alan Cox <alan@redhat.com>


May need to tweak polled isapnp support (or add it) to avoid the WARN but
I will take care of it
