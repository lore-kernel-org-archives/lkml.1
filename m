Return-Path: <linux-kernel-owner+w=401wt.eu-S934044AbXJSStY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044AbXJSStY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936500AbXJSSs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:48:29 -0400
Received: from mga07.intel.com ([143.182.124.22]:44523 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936529AbXJSSs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:48:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,301,1188802800"; 
   d="scan'208";a="301749372"
Date: Fri, 19 Oct 2007 11:45:35 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Eric Biederman <ebiederm@xmission.com>
Subject: Re: [PATCH 0/9] Remove 'irq' argument from all irq handlers
Message-ID: <20071019184535.GB1847@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20071019075443.GA6407@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019075443.GA6407@havoc.gtf.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 03:54:43AM -0400, Jeff Garzik wrote:
> 
> WARNING NOT FOR MERGE WARNING NOT FOR MERGE WARNING NOT FOR MERGE

then whats the point ?

> 
> This posting is just to demonstrate something that I have been keeping
> alive in the background.  I have no urge to push it upstream anytime
> soon.

why not? 

--mgross

> 
> The overwhelming majority of drivers do not ever bother with the 'irq'
> argument that is passed to each driver's irq handler.
> 
> Of the minority of drivers that do use the arg, the majority of those
> have the irq number stored in their private-info structure somewhere.
> 
> There are a tiny few -- a couple Mac drivers -- which do weird things
> with that argument, but that's it.
> 
> For the large sweeps through the tree, these patches are grouped into
> "trivial" changes -- simply removing the unused irq arg -- or all other
> changes.
> 
>    [IRQ ARG REMOVAL] core interrupt delivery infrastructure updates
>    [IRQ ARG REMOVAL] various non-trivial arch updates
>    [IRQ ARG REMOVAL] trivial arch updates
>    [IRQ ARG REMOVAL] non-trivial driver updates
>    [IRQ ARG REMOVAL] trivial net driver updates
>    [IRQ ARG REMOVAL] trivial sound driver updates
>    [IRQ ARG REMOVAL] trivial scsi driver updates
>    [IRQ ARG REMOVAL] trivial driver updates
>    [IRQ ARG REMOVAL] x86-64 build fixes, cleanups
> 
> WARNING NOT FOR MERGE WARNING NOT FOR MERGE WARNING NOT FOR MERGE
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
