Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222AbZKSLr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbZKSLr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 06:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZKSLr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 06:47:27 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:52370 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751558AbZKSLr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 06:47:26 -0500
Date: Thu, 19 Nov 2009 19:47:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix algorithm and driver duplicate registered
Message-ID: <20091119114730.GC6392@gondor.apana.org.au>
References: <20091119003202.GA28448@youquan-linux.bj.intel.com> <20091119001827.GC2315@gondor.apana.org.au> <20091119110222.GA19379@youquan-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119110222.GA19379@youquan-linux.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 06:02:22AM -0500, Youquan,Song wrote:
> 
> I have watched crypto_alg_list includes several duplicate algorithms
> with same algorithm name and driver name. 
> Since they are the same algorithms, one is only needed. otherwise,it
> will make some confusion.

Can you show me a sample /proc/crypto showing this problem and how
you created it?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
