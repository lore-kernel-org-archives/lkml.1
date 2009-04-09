Return-Path: <linux-kernel-owner+w=401wt.eu-S933904AbZDINSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbZDINSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761310AbZDINST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:18:19 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:54804 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754511AbZDINSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:18:18 -0400
Date: Thu, 9 Apr 2009 21:18:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-crypto@vger.kernel.org, arjan@linux.intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [2.6.30-rc1] device-mapper: table: 254:0: crypt: Error
	allocating crypto tfm
Message-ID: <20090409131805.GA2059@gondor.apana.org.au>
References: <8db1092f0904081235x58081f1by842ab45ad861e294@mail.gmail.com> <20090409021804.GA1756@gondor.apana.org.au> <20090409023547.GA1878@gondor.apana.org.au> <8db1092f0904090546j54ac6759i9c36f214ce1109bc@mail.gmail.com> <49DDF2AF.50308@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DDF2AF.50308@trash.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 03:05:51PM +0200, Patrick McHardy wrote:
>
> It also seems to fix a netfilter problem with modules not loaded
> automatically anymore.

They should still autoload, but now you need to retry the operation
manually :)
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
