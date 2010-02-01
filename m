Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0BAKsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:48:52 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:44236 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753385Ab0BAKsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:48:50 -0500
Date: Mon, 1 Feb 2010 21:48:46 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>
Subject: Re: linux-next: crypto-current tree build warning
Message-ID: <20100201104846.GA1170@gondor.apana.org.au>
References: <20100201110709.9de06b42.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201110709.9de06b42.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 11:07:09AM +1100, Stephen Rothwell wrote:
> Hi Herbert,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> drivers/char/random.c: In function 'random_write':
> drivers/char/random.c:1104: warning: unused variable 'inode'
> 
> Introduced by commit b9b06a1fda275559492f8b083927fde4cec641dc ("random:
> drop weird m_time/a_time manipulation") which removed the last usage of
> "inode".

I've fixed it in my tree.

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
