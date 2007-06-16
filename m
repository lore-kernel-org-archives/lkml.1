Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbXFPN5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbXFPN5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 09:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbXFPN46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 09:56:58 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44028 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbXFPN45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 09:56:57 -0400
Date: Sat, 16 Jun 2007 07:56:55 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Message-ID: <20070616135655.GL8154@parisc-linux.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org> <1181986686.25228.639.camel@pmac.infradead.org> <200706161226.40875.arnd@arndb.de> <200706161321.35940.arnd@arndb.de> <1181993652.25228.690.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181993652.25228.690.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 12:34:11PM +0100, David Woodhouse wrote:
> You're right. My question was probably not relevant -- all these 64-bit
> architectures cope with misaligned loads anyway. If we ever have to deal
> with 32-bit compat on a 64-bit architecture which can't handle
> misalignment, I'm just going to hide under my desk and never come out.

... 32-bit compat on a 64-bit architecture where the 32-bit architecture
aligned 64-bit quantities to 32-bit boundaries ...

> > On x86_64, misaligned loads are always ok, so gcc never needs to
> > care about this, even attribute((packed)) does not cause byte access
> > here.
> 
> IA64 too, but it'll be handled there too -- either naturally or by
> fixups; it doesn't matter.

Yes.  iirc, McKinley and later handle misaligned loads within a cacheline
without interrupting.  Merced would interrupt on every misaligned load.
