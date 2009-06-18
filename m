Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbZFRBPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbZFRBPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 21:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZFRBPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 21:15:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:29461 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbZFRBPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 21:15:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,240,1243839600"; 
   d="scan'208";a="155827732"
Date: Thu, 18 Jun 2009 09:15:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slqbinfo doesn't exist...
Message-ID: <20090618011532.GA19732@localhost>
References: <20090617183851.GA15429@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617183851.GA15429@bombadil.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyle,

On Thu, Jun 18, 2009 at 02:38:51AM +0800, Kyle McMartin wrote:
> From: Kyle McMartin <kyle@redhat.com>
> 
> Commit 35efa5e993a7a00a50b87d2b7725c3eafc80b083 which added a page-types
> tool introduced a reference to slqbinfo in the Makefile, which, doesn't
> exist... This is currently causing my rawhide builds to fail.

This fix should be in the latest git tree. Sorry for all the inconvenience!

Thanks,
Fengguang


> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
> ---
> 
> diff --git a/Documentation/vm/Makefile b/Documentation/vm/Makefile
> index 27479d4..5bd269b 100644
> --- a/Documentation/vm/Makefile
> +++ b/Documentation/vm/Makefile
> @@ -2,7 +2,7 @@
>  obj- := dummy.o
>  
>  # List of programs to build
> -hostprogs-y := slabinfo slqbinfo page-types
> +hostprogs-y := slabinfo page-types
>  
>  # Tell kbuild to always build the programs
>  always := $(hostprogs-y)
