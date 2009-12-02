Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbZLBNbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbZLBNbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZLBNbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:31:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:28448 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbZLBNbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:31:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217909077"
Date: Wed, 2 Dec 2009 21:31:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/24] HWPOISON: remove the free buddy page handler
Message-ID: <20091202133101.GD13277@localhost>
References: <20091202031231.735876003@intel.com> <20091202043044.878843398@intel.com> <20091202131330.GF18989@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202131330.GF18989@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 09:13:30PM +0800, Andi Kleen wrote:
> On Wed, Dec 02, 2009 at 11:12:41AM +0800, Wu Fengguang wrote:
> > The buddy page has already be handled in the very beginning.
> > So remove redundant code.
> 
> I think I prefer the table to be complete, even if some of the 
> cases might not happen currently. A BUG() would be reasonable though.

I'd prefer not to carry around some useless bytes in kernel.

What if we replace it with a comment line in the table?

Thanks,
Fengguang
