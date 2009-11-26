Return-Path: <linux-kernel-owner+w=401wt.eu-S1759976AbZKZANX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976AbZKZANX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 19:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759967AbZKZANV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 19:13:21 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:53774 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759966AbZKZANV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 19:13:21 -0500
Date: Thu, 26 Nov 2009 08:13:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix aesni algorithm implementation without test
Message-ID: <20091126001323.GA1193@gondor.apana.org.au>
References: <20091126004226.GA32230@youquan-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126004226.GA32230@youquan-linux.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 07:42:27PM -0500, Youquan,Song wrote:
> when load aesni-intel driver,kernel will report no test for some algorithm
> with AES-NI. The strange information as following:
> 
> alg: No test for __aes-aesni (__driver-aes-aesni)
> alg: No test for __ecb-aes-aesni (__driver-ecb-aes-aesni)
> alg: No test for __cbc-aes-aesni (__driver-cbc-aes-aesni)
> alg: No test for __ecb-aes-aesni (cryptd(__driver-ecb-aes-aesni)
> 
> crypto_alg's cra_name is use to descript algorithm itself, do not care the 
> concrete implement. So this patch unify them and also can fix the algorithm
> implementation without test. 
> 
> Signed-off-by: Youquan, Song <youquan.song@intel.com>

No this is bogus.  The algorithm name is specifically set to these
values because they're not meant to be used directly by anyone other
than aesni.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
