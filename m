Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZJZUjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZJZUjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZJZUjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:39:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:34698 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbZJZUjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:39:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,628,1249282800"; 
   d="scan'208";a="203827515"
Date: Mon, 26 Oct 2009 13:39:34 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [X86] PCI: Use generic cacheline sizing instead of per-vendor
 tests.
Message-ID: <20091026133934.57320657@jbarnes-g45>
In-Reply-To: <20091014203139.GA2336@redhat.com>
References: <20091014203139.GA2336@redhat.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009 16:31:39 -0400
Dave Jones <davej@redhat.com> wrote:

> Instead of the PCI code needing to have code to determine the 
> cacheline size of each processor, use the data the cpu identification
> code should have already determined during early boot.
> 
> (The vendor checks are also incomplete, and don't take into account
>  modern CPUs)
> 
> I've been carrying a variant of this code in Fedora for a while,
> that prints debug information.  There are a number of cases where we
> are currently setting the PCI cacheline size to 32 bytes, when the CPU
> cacheline size is 64 bytes.  With this patch, we set them both the
> same.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Applied this; had to fix up a few conflicts due to Tejun's recent CLS
improvements though...

-- 
Jesse Barnes, Intel Open Source Technology Center
