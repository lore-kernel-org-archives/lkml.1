Return-Path: <linux-kernel-owner+w=401wt.eu-S967404AbXFHDF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967404AbXFHDF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 23:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966629AbXFHDFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 23:05:18 -0400
Received: from holomorphy.com ([66.93.40.71]:42222 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966614AbXFHDFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 23:05:17 -0400
Date: Thu, 7 Jun 2007 20:06:29 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mark Lord <lkml@rtr.ca>,
       Andi Kleen <ak@suse.de>
Subject: Re: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
Message-ID: <20070608030629.GW6909@holomorphy.com>
References: <20070608023551.GJ15426@holomorphy.com> <20070607194156.d4aacf4c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607194156.d4aacf4c.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 19:35:51 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:
>> PAE is useful for more than supporting more than 4GB RAM. It supports
>> expanded swapspace and NX executable protections. Some users may want
>> NX or expanded swapspace support without the overhead or instability
>> of highmem. For these reasons, the following patch divorces
>> CONFIG_X86_PAE from CONFIG_HIGHMEM64G.

On Thu, Jun 07, 2007 at 07:41:56PM -0700, Andrew Morton wrote:
> Do (CONFIG_X86_PAE && !CONFIG_HIGHMEM64G) and (!CONFIG_X86_PAE && CONFIG_HIGHMEM64G)
> kernels actually work?  I wouldn't be surprised if there are places where we used
> the incorrect one.

!CONFIG_X86_PAE && CONFIG_HIGHMEM64G doesn't make sense and is not allowed
by this patch. CONFIG_X86_PAE && !CONFIG_HIGHMEM64G works here.


-- wli
