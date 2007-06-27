Return-Path: <linux-kernel-owner+w=401wt.eu-S1763272AbXF0WAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763272AbXF0WAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758395AbXF0WAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:00:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57376 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758017AbXF0WAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:00:20 -0400
Date: Wed, 27 Jun 2007 23:06:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>, mm-commits@vger.kernel.org
Subject: Re: [PATCH] balance parenthesis in serial core
Message-ID: <20070627230607.1f65a79b@the-village.bc.nu>
In-Reply-To: <200706272222.01300.m.kozlowski@tuxland.pl>
References: <200706271030.l5RAUgKE015163@imap1.linux-foundation.org>
	<200706272222.01300.m.kozlowski@tuxland.pl>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 22:22:00 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	This patch balances the parenthesis imbalance in serial core.
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Ack although the right thing to do is to remove these checks (and I'm
doing so in my tree). They are a waste of code for a path that basically
never occurs, is never performance critical and is asking for trouble in
future.
