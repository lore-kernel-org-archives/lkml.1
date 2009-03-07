Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbZCGKqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbZCGKqv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 05:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZCGKqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 05:46:43 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:46296 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752632AbZCGKqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 05:46:42 -0500
Date: Sat, 7 Mar 2009 18:46:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH 6/6] squashfs: Make SquashFS 4 use the new pcomp crypto
	interface
Message-ID: <20090307104637.GB8731@gondor.apana.org.au>
References: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 02:43:14PM +0100, Geert Uytterhoeven wrote:
> Modify SquashFS 4 to use the new "pcomp" crypto interface for decompression,
> instead of calling the underlying zlib library directly. This simplifies e.g.
> the addition of support for hardware decompression and different decompression
> algorithms.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Cc: Phillip Lougher <phillip@lougher.demon.co.uk>

I've applied patches 1-5.  I'd like to see an ack on this before
applying it.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
