Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbZKWMXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbZKWMXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 07:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbZKWMXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 07:23:54 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:58031 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756945AbZKWMXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:23:54 -0500
Date: Mon, 23 Nov 2009 20:23:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Add ghash algorithm test before provide to users
Message-ID: <20091123122357.GE6424@gondor.apana.org.au>
References: <20091119004246.GB28448@youquan-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119004246.GB28448@youquan-linux.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 07:42:46PM -0500, Youquan,Song wrote:
> Add ghash algorithm test before provide it to users
> 
> Signed-off-by: Youquan, Song <youquan.song@intel.com>

Patch applied.

> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index 9963b18..fea00cd 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -1003,6 +1003,23 @@ static struct hash_testvec tgr128_tv_template[] = {
>  	},
>  };
>  
> +#define GHASH_TEST_VECTORS 1
> +
> +static struct hash_testvec ghash_tv_template[] =
> +{
> +	{
> +
> +		.key	= "\xdf\xa6\xbf\x4d\xed\x81\xdb\x03\xff\xca\xff\x95\xf8\x30\xf0\x61",
> +		.ksize	= 16,
> +		.plaintext = "\x95\x2b\x2a\x56\xa5\x60\x04a\xc0\xb3\x2b\x66\x56\xa0\x5b\x40\xb6",
> +		.psize	= 16,
> +		.digest	= "\xda\x53\xeb\x0a\xd2\xc5\x5b\xb6"
> +			  "\x4f\xc4\x80\x2c\xc3\xfe\xda\x60",
> +	},
> +};
> +
> +/*
> + * HMAC-MD5 test vectors from RFC2202
>  /*
>   * HMAC-MD5 test vectors from RFC2202
>   * (These need to be fixed to not use strlen).

This adds two bogus lines.  I've removed them for you but please
be more careful next time.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
