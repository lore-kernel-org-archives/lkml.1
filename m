Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab0BSIax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 03:30:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54049 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab0BSIaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 03:30:52 -0500
Date: Fri, 19 Feb 2010 08:30:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michael Bohan <mbohan@codeaurora.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-arm-kernel@lists.infradead.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-arm-msm@vger.kernel.org
Subject: Re: Kernel panic due to page migration accessing memory holes
Message-ID: <20100219083006.GA19649@n2100.arm.linux.org.uk>
References: <4B7C8DC2.3060004@codeaurora.org> <20100218100324.5e9e8f8c.kamezawa.hiroyu@jp.fujitsu.com> <4B7CF8C0.4050105@codeaurora.org> <20100218183604.95ee8c77.kamezawa.hiroyu@jp.fujitsu.com> <20100218100432.GA32626@csn.ul.ie> <4B7DEDB0.8030802@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7DEDB0.8030802@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 05:47:28PM -0800, Michael Bohan wrote:
> I am actually using the pfn_valid implementation FLATMEM in  
> arch/arm/include/asm/memory.h.  This one is very similar to the  
> asm-generic, and has no knowledge of the holes.

Later kernels have a pfn_valid() which does have hole functionality.
