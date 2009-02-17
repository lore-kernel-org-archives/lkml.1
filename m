Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbZBQROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbZBQROU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbZBQROF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:14:05 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:35942 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752778AbZBQROD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:14:03 -0500
Date: Tue, 17 Feb 2009 12:06:37 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-crypto@vger.kernel.org, Geert.Uytterhoeven@sonycom.com
Subject: Re: [PATCH] Export symbol ksize()
In-Reply-To: <84144f020902170903g5756cf4cy57f98cd5955ff2e3@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0902171205390.15929@qirst.com>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>  <20090212104349.GA13859@gondor.apana.org.au>  <1234435521.28812.165.camel@penberg-laptop>  <20090212105034.GC13859@gondor.apana.org.au>  <1234454104.28812.175.camel@penberg-laptop> 
 <20090215133638.5ef517ac.akpm@linux-foundation.org>  <1234734194.5669.176.camel@calx>  <20090215135555.688ae1a3.akpm@linux-foundation.org>  <1234741781.5669.204.camel@calx>  <alpine.DEB.1.10.0902171115010.29986@qirst.com>
 <84144f020902170903g5756cf4cy57f98cd5955ff2e3@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009, Pekka Enberg wrote:

> Hmm, kmem_cache_size() seems bit pointless to me. For
> kmem_cache_create()'d caches, actual allocated size should be more or
> less optimal with no extra space.

Cacheline alignment and word alignment etc etc can still add some space to
the object.

