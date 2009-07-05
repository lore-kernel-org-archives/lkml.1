Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZGELOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZGELOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 07:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZGELOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 07:14:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:43551 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbZGELOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 07:14:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,351,1243839600"; 
   d="scan'208";a="161636150"
Date: Sun, 5 Jul 2009 19:14:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/5] add per-zone statistics to show_free_areas()
Message-ID: <20090705111440.GA2064@localhost>
References: <20090705182259.08F6.A69D9226@jp.fujitsu.com> <20090705110548.GA1898@localhost> <20090705200757.0911.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705200757.0911.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 07:09:55PM +0800, KOSAKI Motohiro wrote:
> > On Sun, Jul 05, 2009 at 05:23:35PM +0800, KOSAKI Motohiro wrote:
> > > Subject: [PATCH] add per-zone statistics to show_free_areas()
> > > 
> > > Currently, show_free_area() mainly display system memory usage. but it
> > > doesn't display per-zone memory usage information.
> > > 
> > > However, if DMA zone OOM occur, Administrator definitely need to know
> > > per-zone memory usage information.
> > 
> > DMA zone is normally lowmem-reserved. But I think the numbers still
> > make sense for DMA32.
> > 
> > Acked-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> Yes, x86_64 have DMA and DMA32, but almost 64-bit architecture have
> 2 or 4GB "DMA" zone.

Ah Yes!

> Then, I wrote the patch description by generic name.

OK.

Thanks,
Fengguang
