Return-Path: <linux-kernel-owner+w=401wt.eu-S1763465AbYCDBnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763465AbYCDBnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 20:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbYCDBnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 20:43:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:28436 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756372AbYCDBnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 20:43:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,441,1199692800"; 
   d="scan'208";a="303462585"
Date: Mon, 3 Mar 2008 17:43:06 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v3
Message-ID: <20080304014306.GC28006@linux-os.sc.intel.com>
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080303230336.042604000@linux-os.sc.intel.com> <20080304012012.GB22431@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304012012.GB22431@infradead.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 08:20:12PM -0500, Christoph Hellwig wrote:
> On Mon, Mar 03, 2008 at 03:02:46PM -0800, Suresh Siddha wrote:
> > +	/*
> > +	 * Memory allocation at the first usage of the FPU and other state.
> > +	 */
> > +	if (!tsk->thread.xstate)
> > +		tsk->thread.xstate = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
> 
> Please don't do over 80 char lines.

Ok.

>  Also don't we need some kind of error handling here?

Currently it uses SLAB_PANIC.

thanks,
suresh
