Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbZKWKLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbZKWKLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbZKWKLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:11:14 -0500
Received: from mga10.intel.com ([192.55.52.92]:56231 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756786AbZKWKLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:11:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,271,1257148800"; 
   d="scan'208";a="516470833"
Date: Mon, 23 Nov 2009 12:47:24 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Youquan,Song" <youquan.song@linux.intel.com>,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix algorithm and driver duplicate registered
Message-ID: <20091123174724.GB14372@youquan-linux.bj.intel.com>
References: <20091119003202.GA28448@youquan-linux.bj.intel.com> <20091119001827.GC2315@gondor.apana.org.au> <20091119110222.GA19379@youquan-linux.bj.intel.com> <20091119114730.GC6392@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119114730.GC6392@gondor.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 07:47:30PM +0800, Herbert Xu wrote:
> On Thu, Nov 19, 2009 at 06:02:22AM -0500, Youquan,Song wrote:
> > 
> > I have watched crypto_alg_list includes several duplicate algorithms
> > with same algorithm name and driver name. 
> > Since they are the same algorithms, one is only needed. otherwise,it
> > will make some confusion.
> 

Hi Herbert,

The alg->cra_name and alg->cra_driver_name, from the description,
cra_name is the algorithm name and cra_driver_name is the driver name.
But when I read the code, I often get confuse about these two names.
They often mix each other.  

Can you give me some instruction about them? or Can we make them more clear? Thanks. 

-Youquan
