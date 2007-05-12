Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbXELIhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbXELIhz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 04:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbXELIhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 04:37:47 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36286 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755052AbXELIhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 04:37:47 -0400
Date: Sat, 12 May 2007 01:37:55 -0700
From: Paul Jackson <pj@sgi.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: nickpiggin@yahoo.com.au, ray-lk@madrabbit.org, mingo@elte.hu,
       ck@vds.kolivas.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: swap prefetch improvements
Message-Id: <20070512013755.603cfcc3.pj@sgi.com>
In-Reply-To: <200705121821.48515.kernel@kolivas.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<200705121728.34987.kernel@kolivas.org>
	<20070512011454.50ba68a5.pj@sgi.com>
	<200705121821.48515.kernel@kolivas.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con wrote:
> Ok so change the default value for swap_prefetch to 0 when CPUSETS is enabled? 

I don't see why that special case for cpusets is needed.

I'm suggesting making no special cases for CPUSETS at all, until and
unless we find reason to.

In other words, I'm suggesting simply removing the patch lines:

-	depends on SWAP
+	depends on SWAP && !CPUSETS

I see no other mention of cpusets in your patch.  That's fine by me.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
