Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZLWL7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZLWL7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 06:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZLWL7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 06:59:13 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:39126 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875AbZLWL7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 06:59:13 -0500
Date: Wed, 23 Dec 2009 19:59:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       chaohong.guo@intel.com, youquan.song@intel.com
Subject: Re: [Resend PATCH]crypto: Fix complain about lack test for
	internal used algorithm
Message-ID: <20091223115909.GA29744@gondor.apana.org.au>
References: <200912102013.59329.david-b@pacbell.net> <20091211043849.GA18007@suse.de> <1260509771.12346.138.camel@localhost> <20091211132321.GA17228@youquan-linux.bj.intel.com> <20091211060448.GA28704@gondor.apana.org.au> <20091219094043.GA23639@youquan-linux.bj.intel.com> <20091219022917.GA19431@gondor.apana.org.au> <20091219150736.GA5368@youquan-linux.bj.intel.com> <20091219094240.GA21546@gondor.apana.org.au> <20091221103829.GA22144@youquan-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221103829.GA22144@youquan-linux.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 05:38:29AM -0500, Youquan,Song wrote:
> When load aesni-intel and ghash_clmulni-intel driver,kernel will complain no
>  test for some internal used algorithm.
> The strange information as following:
> 
> alg: No test for __aes-aesni (__driver-aes-aesni)
> alg: No test for __ecb-aes-aesni (__driver-ecb-aes-aesni)
> alg: No test for __cbc-aes-aesni (__driver-cbc-aes-aesni)
> alg: No test for __ecb-aes-aesni (cryptd(__driver-ecb-aes-aesni)
> alg: No test for __ghash (__ghash-pclmulqdqni)
> alg: No test for __ghash (cryptd(__ghash-pclmulqdqni))
> 
> This patch add NULL test entries for these algorithm and driver.  
> 
> Signed-off-by: Youquan, Song <youquan.song@intel.com>
> Signed-off-by: Ying, Huang <ying.huang@intel.com>

Patch applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
