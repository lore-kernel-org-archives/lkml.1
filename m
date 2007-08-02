Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbXHBDFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbXHBDFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 23:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbXHBDE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 23:04:59 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:57373 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbXHBDE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 23:04:58 -0400
Date: Thu, 2 Aug 2007 12:04:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Matthew Wilcox <matthew@wil.cx>, Kyle McMartin <kyle@parisc-linux.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix WARN_ON() on bitfield ops for all other archs
Message-ID: <20070802030410.GA18404@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexey Dobriyan <adobriyan@sw.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Kyle McMartin <kyle@parisc-linux.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org
References: <20070801221838.GA9010@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801221838.GA9010@osiris.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 12:18:38AM +0200, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Fixes WARN_ON() on bitfiels ops for all architectures that have
> been left out in 8d4fbcfbe0a4bfc73e7f0297c59ae514e1f1436f.
> 
> Cc: Alexey Dobriyan <adobriyan@sw.ru>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Kyle McMartin <kyle@parisc-linux.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Paul Mundt <lethal@linux-sh.org>
