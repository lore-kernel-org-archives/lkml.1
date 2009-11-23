Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbZKWLbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbZKWLbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZKWLbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:31:23 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:44355 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756924AbZKWLbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:31:23 -0500
Date: Mon, 23 Nov 2009 19:31:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix algorithm and driver duplicate registered
Message-ID: <20091123113126.GA6297@gondor.apana.org.au>
References: <20091119003202.GA28448@youquan-linux.bj.intel.com> <20091119001827.GC2315@gondor.apana.org.au> <20091119110222.GA19379@youquan-linux.bj.intel.com> <20091119114730.GC6392@gondor.apana.org.au> <20091123174724.GB14372@youquan-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123174724.GB14372@youquan-linux.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 12:47:24PM -0500, Youquan,Song wrote:
>
> The alg->cra_name and alg->cra_driver_name, from the description,
> cra_name is the algorithm name and cra_driver_name is the driver name.

For each algorithm you may have an arbitrary number of drivers
implementing it.  The driver name must be unique.  However,
duplicates are allowed so that a new version of a driver may
be loaded while the older instances of it are still in use.

> But when I read the code, I often get confuse about these two names.
> They often mix each other.  
> 
> Can you give me some instruction about them? or Can we make them more clear? Thanks. 

Well can you tell me what exactly confuses you?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
