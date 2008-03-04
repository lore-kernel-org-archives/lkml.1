Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbYCDBUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbYCDBUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 20:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbYCDBUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 20:20:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57569 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbYCDBUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 20:20:20 -0500
Date: Mon, 3 Mar 2008 20:20:12 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v3
Message-ID: <20080304012012.GB22431@infradead.org>
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080303230336.042604000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303230336.042604000@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 03:02:46PM -0800, Suresh Siddha wrote:
> +	/*
> +	 * Memory allocation at the first usage of the FPU and other state.
> +	 */
> +	if (!tsk->thread.xstate)
> +		tsk->thread.xstate = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);

Please don't do over 80 char lines.  Also don't we need some kind of
error handling here?

