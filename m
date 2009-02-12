Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbZBLKpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbZBLKpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757061AbZBLKpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:45:24 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38287 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842AbZBLKpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:45:23 -0500
Subject: Re: [PATCH] Export symbol ksize()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-crypto@vger.kernel.org,
       Geert.Uytterhoeven@sonycom.com
In-Reply-To: <20090212104349.GA13859@gondor.apana.org.au>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>
	 <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com>
	 <20090210134651.GA5115@epbyminw8406h.minsk.epam.com>
	 <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI>
	 <20090212104349.GA13859@gondor.apana.org.au>
Date: Thu, 12 Feb 2009 12:45:21 +0200
Message-Id: <1234435521.28812.165.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 04:06:53PM +0200, Pekka J Enberg wrote:
> > Herbert, what do you think of this (untested) patch? Alternatively, we 
> > could do something like kfree_secure() but it seems overkill for this one 
> > call-site.

On Thu, 2009-02-12 at 18:43 +0800, Herbert Xu wrote:
> I don't understand why you want to limit the use of ksize.

Because the API was being widely abused in the nommu code, for example.
I'd rather not add it back for this special case which can be handled
otherwise.

			Pekka

