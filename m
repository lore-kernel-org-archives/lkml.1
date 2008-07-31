Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbYGaXOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbYGaXOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 19:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYGaXNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 19:13:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35699 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752163AbYGaXNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 19:13:54 -0400
Date: Thu, 31 Jul 2008 23:56:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/net/skfp/pmf.c: Use offsetof() macro
Message-ID: <20080731235614.7e9e4fa7@lxorguk.ukuu.org.uk>
In-Reply-To: <s5hsktqj8np.wl%tiwai@suse.de>
References: <s5hsktqj8np.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 18:55:06 +0200
Takashi Iwai <tiwai@suse.de> wrote:

> Self-baked macros cause bunch of compile warnings like below:
> 
>   CC [M]  drivers/net/skfp/pmf.o
>   CC      net/ipv4/fib_semantics.o
> drivers/net/skfp/pmf.c:86: warning: cast from pointer to integer of different size
> drivers/net/skfp/pmf.c:87: warning: cast from pointer to integer of different size
> ...
> 
> Use the standard offsetof() macro instead.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Acked-by: Alan Cox <alan@redhat.com>

(And this is better than the patch I sent to netdev so Ack in definite
preference to the one I posted)
