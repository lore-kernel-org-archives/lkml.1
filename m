Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbZLKGEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbZLKGEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 01:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755380AbZLKGEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 01:04:45 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:43012 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754855AbZLKGEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 01:04:44 -0500
Date: Fri, 11 Dec 2009 14:04:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix complain about lack test for internal used
	algorithm
Message-ID: <20091211060448.GA28704@gondor.apana.org.au>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <200912101939.30446.david-b@pacbell.net> <20091211034711.GA2773@suse.de> <200912102013.59329.david-b@pacbell.net> <20091211043849.GA18007@suse.de> <1260509771.12346.138.camel@localhost> <20091211132321.GA17228@youquan-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211132321.GA17228@youquan-linux.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 08:23:21AM -0500, Youquan,Song wrote:
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

I'd prefer to just add nul testmgr entries for these algorithms.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
