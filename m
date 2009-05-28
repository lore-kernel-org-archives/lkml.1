Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbZE1Kfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbZE1Kfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 06:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZE1Kfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 06:35:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53552 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZE1Kfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 06:35:32 -0400
Date: Thu, 28 May 2009 12:42:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       Taketoshi Sakuraba <taketoshi.sakuraba.hc@hitachi.com>
Subject: Re: [PATCH] [4/16] HWPOISON: Add support for poison swap entries v2
Message-ID: <20090528104214.GF1065@one.firstfloor.org>
References: <200905271012.668777061@firstfloor.org> <20090527201230.19B1C1D0286@basil.firstfloor.org> <4A1E4F80.9090404@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1E4F80.9090404@hitachi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 05:46:56PM +0900, Hidehiro Kawai wrote:
> > + */
> > +#ifdef CONFIG_MEMORY_FAILURE
> > +#define SWP_HWPOISON_NUM 1
> > +#define SWP_HWPOISON		(MAX_SWAPFILES + 1)
> > +#else
> > +#define SWP_HWPOISON_NUM 0
> > +#endif
> > +
> > +#define MAX_SWAPFILES \
> > +	((1 << MAX_SWAPFILES_SHIFT) - SWP_MIGRATION_NUM - SWP_HWPOISON_NUM - 1)
> 
> I don't prefer this fix against the overflow issue.
> For example, if both CONFIG_MIGRATION and CONFIG_MEMORY_FAILURE are
> undefined, MAX_SWAPFILES is defined as 31.  But we should be able to
> use up to 32 swap files/devices!

Ok. Applied thanks. 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
