Return-Path: <linux-kernel-owner+w=401wt.eu-S1758314AbYG0RpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314AbYG0RpC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 13:45:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbYG0Roy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 13:44:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42434 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750840AbYG0Rox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 13:44:53 -0400
Date: Sun, 27 Jul 2008 18:27:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Karsten Keil <kkeil@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       ppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] isdn: mISDN HFC PCI support depends on virt_to_bus()
Message-ID: <20080727182709.1dac0556@lxorguk.ukuu.org.uk>
In-Reply-To: <20080728023732.090aff83.sfr@canb.auug.org.au>
References: <20080728023732.090aff83.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 02:37:32 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> On powerpc (allyesconfig build) we get this error:
> 
> drivers/isdn/hardware/mISDN/hfcpci.c:1991: error: implicit declaration of function 'virt_to_bus'
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Can we please not merge new virt_to_bus users and instead fix the actual
code to use the right functions?
