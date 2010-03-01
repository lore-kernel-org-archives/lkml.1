Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab0CAFM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 00:12:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:57662 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0CAFM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 00:12:57 -0500
Date: Sun, 28 Feb 2010 21:15:11 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Mikael Pettersson <mikpe@it.uu.se>, penberg@cs.helsinki.fi,
       Brian Gerst <brgerst@gmail.com>, andi@firstfloor.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
       Herbert@gondor.apana.org.au
Subject: Re: [PATCH v1] compiler: prevent dead store elimination
Message-ID: <20100228211511.60981829@infradead.org>
In-Reply-To: <4B8984EE.8090605@gmail.com>
References: <4B8984EE.8090605@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Feb 2010 21:47:42 +0100
Roel Kluin <roel.kluin@gmail.com> wrote:
> +void secure_bzero(void *p, size_t n)
> +{
> +	memset(p, 0, n);
> +	ARRAY_PREVENT_DSE(p, n);
> +}
> +EXPORT_SYMBOL(secure_bzero);


please don't introduce bzero again to the kernel;

make it secure_memset() please.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
