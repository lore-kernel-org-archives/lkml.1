Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbZBLKv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbZBLKv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758222AbZBLKu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:50:58 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:33836 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758113AbZBLKu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:50:57 -0500
Date: Thu, 12 Feb 2009 18:50:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-crypto@vger.kernel.org,
       Geert.Uytterhoeven@sonycom.com
Subject: Re: [PATCH] Export symbol ksize()
Message-ID: <20090212105034.GC13859@gondor.apana.org.au>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name> <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com> <20090210134651.GA5115@epbyminw8406h.minsk.epam.com> <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI> <20090212104349.GA13859@gondor.apana.org.au> <1234435521.28812.165.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234435521.28812.165.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 12:45:21PM +0200, Pekka Enberg wrote:
> 
> Because the API was being widely abused in the nommu code, for example.
> I'd rather not add it back for this special case which can be handled
> otherwise.

I'm sorry but that's like banning the use of heaters just because
they can abused and cause fires.

I think I've said this to you before but in networking we very much
want to use ksize because the standard case of a 1500-byte packet
has loads of extra room given by kmalloc which all goes to waste
right now.

If we could use ksize then we can stuff loads of metadata in that
space.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
