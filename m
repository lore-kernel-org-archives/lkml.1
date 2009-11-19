Return-Path: <linux-kernel-owner+w=401wt.eu-S932422AbZKSD0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbZKSD0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 22:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932328AbZKSD0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 22:26:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:27431 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327AbZKSD0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 22:26:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,768,1249282800"; 
   d="scan'208";a="570976079"
Date: Thu, 19 Nov 2009 06:02:22 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Youquan,Song" <youquan.song@linux.intel.com>,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix algorithm and driver duplicate registered
Message-ID: <20091119110222.GA19379@youquan-linux.bj.intel.com>
References: <20091119003202.GA28448@youquan-linux.bj.intel.com> <20091119001827.GC2315@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119001827.GC2315@gondor.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 08:18:27AM +0800, Herbert Xu wrote:
> On Wed, Nov 18, 2009 at 07:32:02PM -0500, Youquan,Song wrote:
> > Current kernel, All the algorithms with same algorithm name and driver name
> > are registered. 
> > But the proper behaviour should be only one algorithm be registered when 
> > algorithm and driver name duplicate.
> > 
> > Signed-off-by: Youquan, Song <youquan.song@intel.com>
> 
> This is intentional, in order to allow older implementations to be
> replaced on the fly.
> 
> Is this causing any issues for you?

I have watched crypto_alg_list includes several duplicate algorithms
with same algorithm name and driver name. 
Since they are the same algorithms, one is only needed. otherwise,it
will make some confusion.

Thanks.
