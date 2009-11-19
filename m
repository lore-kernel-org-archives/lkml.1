Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbZKSASZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbZKSASZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 19:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbZKSASY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 19:18:24 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:46699 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752771AbZKSASY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 19:18:24 -0500
Date: Thu, 19 Nov 2009 08:18:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix algorithm and driver duplicate registered
Message-ID: <20091119001827.GC2315@gondor.apana.org.au>
References: <20091119003202.GA28448@youquan-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119003202.GA28448@youquan-linux.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 07:32:02PM -0500, Youquan,Song wrote:
> Current kernel, All the algorithms with same algorithm name and driver name
> are registered. 
> But the proper behaviour should be only one algorithm be registered when 
> algorithm and driver name duplicate.
> 
> Signed-off-by: Youquan, Song <youquan.song@intel.com>

This is intentional, in order to allow older implementations to be
replaced on the fly.

Is this causing any issues for you?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
