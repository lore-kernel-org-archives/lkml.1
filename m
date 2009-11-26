Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbZKZAOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbZKZAOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 19:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759971AbZKZAOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 19:14:12 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:47396 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759968AbZKZAOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 19:14:11 -0500
Date: Thu, 26 Nov 2009 08:14:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix ghash pclmulqdqni algorithm without test
Message-ID: <20091126001415.GB1193@gondor.apana.org.au>
References: <20091126004633.GB32230@youquan-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126004633.GB32230@youquan-linux.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 07:46:33PM -0500, Youquan,Song wrote:
> when load ghash-clmulni-intel driver,kernel will report no test for some algorithm
> with PCLMULQDQ NI. The strange information as following:
> 
> alg: No test for __ghash (__ghash-pclmulqdqni)
> alg: No test for __ghash (cryptd(__ghash-pclmulqdqni))
> 
> crypto_alg's cra_name is use to descript algorithm itself, do not care the 
> concrete implement. So this patch unify them and also can fix the algorithm
> implementation without test. 
> 
> Signed-off-by: Youquan, Song <youquan.song@intel.com>

Please talk to Huang Ying who wrote these patches.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
