Return-Path: <linux-kernel-owner+w=401wt.eu-S937925AbXG0Vsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937925AbXG0Vsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 17:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758526AbXG0Vsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 17:48:35 -0400
Received: from mail.suse.de ([195.135.220.2]:47851 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479AbXG0Vse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 17:48:34 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: eranian@hpl.hp.com
Subject: Re: [PATCH] perfctr_watchdog: do not BUG_ON() when MSR is unknown
Date: Fri, 27 Jul 2007 23:48:28 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       B.Steinbrink@gmx.de
References: <20070727124934.GD9828@frankl.hpl.hp.com>
In-Reply-To: <20070727124934.GD9828@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707272348.28943.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 July 2007 14:49:34 Stephane Eranian wrote:
> Hi,
> 
> Here is a small patch to change the behavior of the PMU msr allocator
> to avoid BUG_ON() when the MSR is unknwon. Instead, it now returns
> ok, which means "I do not manage". The current allocator is not
> yet managing the full set of PMU registers (e.g., GLOBAL_* on Core 2).
> 
> 
>     [watchdog] do not BUG_ON() in the MSR allocator if MSR is unknown, return ok instead
>     
>     signed-off-by: Stephane Eranian <eranian@hpl.hp.com>

Applied both patches, but can you in future patches please not indent
the Signed-off-by and also capitalize it properly? Thanks.

-Andi
