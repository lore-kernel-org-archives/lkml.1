Return-Path: <linux-kernel-owner+w=401wt.eu-S1758237AbXGLRxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbXGLRxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 13:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbXGLRx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 13:53:27 -0400
Received: from waste.org ([66.93.16.53]:44609 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbXGLRx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 13:53:26 -0400
Date: Thu, 12 Jul 2007 12:53:09 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070712175308.GW11166@waste.org>
References: <20070706222651.GG5777@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070706222651.GG5777@v2.random>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 12:26:51AM +0200, Andrea Arcangeli wrote:
> The original idea of having a software page size larger than a
> hardware page size, originated at SUSE by myself and Andi Kleen while
> helping AMD to design their amd64 cpu,

Original? This was done on VAXen and in Mach ages ago.

On Linux, there've already been two implementations, one by Hugh
Dickens and an expanded version by Bill Irwin (presented at OLS in
2003).

Bill's patch was notable for going to heroic efforts to maintain
binary compatibility, basically separating the userspace notion of the
ABI's page size from the kernel's. How's your version fair here?

-- 
Mathematics is the supreme nostalgia of our time.
