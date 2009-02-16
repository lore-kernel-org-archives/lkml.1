Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZBPB5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZBPB5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 20:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbZBPB5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 20:57:21 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:35024 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753245AbZBPB5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 20:57:20 -0500
Date: Mon, 16 Feb 2009 09:57:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-crypto@vger.kernel.org, Geert.Uytterhoeven@sonycom.com
Subject: Re: [PATCH] Export symbol ksize()
Message-ID: <20090216015706.GA13948@gondor.apana.org.au>
References: <1234454104.28812.175.camel@penberg-laptop> <20090215133638.5ef517ac.akpm@linux-foundation.org> <1234734194.5669.176.camel@calx> <20090215135555.688ae1a3.akpm@linux-foundation.org> <1234741781.5669.204.camel@calx> <20090215170052.44ee8fd5.akpm@linux-foundation.org> <20090216012110.GA13575@gondor.apana.org.au> <1234747726.5669.215.camel@calx> <20090216015229.GA13892@gondor.apana.org.au> <1234749279.5669.225.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234749279.5669.225.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 07:54:39PM -0600, Matt Mackall wrote:
>
> I'll bite.. what's wrong with page boundaries? Do we play per-SKB TLB
> games in virtual network drivers?

Because virtual physical memory is not physically contiguous.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
