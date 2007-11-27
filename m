Return-Path: <linux-kernel-owner+w=401wt.eu-S1759790AbXK0WQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790AbXK0WQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbXK0WQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:16:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46681 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbXK0WQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:16:32 -0500
Date: Tue, 27 Nov 2007 23:16:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, pageexec@freemail.hu,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm: Prevent dereferencing non-allocated per_cpu variables
Message-ID: <20071127221628.GG24223@one.firstfloor.org>
References: <20071127215052.090968000@sgi.com> <20071127215054.660250000@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127215054.660250000@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 01:50:53PM -0800, travis@sgi.com wrote:
> Change loops controlled by 'for (i = 0; i < NR_CPUS; i++)' to use
> 'for_each_possible_cpu(i)' when there's a _remote possibility_ of
> dereferencing a non-allocated per_cpu variable involved.
> 
> All files except mm/vmstat.c are x86 arch.
> 
> Based on 2.6.24-rc3-mm1 .
> 
> Thanks to pageexec@freemail.hu for pointing this out.

Looks good to me. 2.6.24 candidate.

-Andi

