Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbZBTJn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbZBTJn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 04:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbZBTJnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 04:43:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753915AbZBTJns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 04:43:48 -0500
Date: Fri, 20 Feb 2009 01:43:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: airlied@linux.ie, benh@kernel.crashing.org,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: Preserve SHMLBA bits in hash key for _DRM_SHM
 mappings.
Message-Id: <20090220014334.c3d66c6b.akpm@linux-foundation.org>
In-Reply-To: <20090220.005414.260531522.davem@davemloft.net>
References: <20090218.154102.122148224.davem@davemloft.net>
	<20090219152726.9551fb7a.akpm@linux-foundation.org>
	<20090220.005414.260531522.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 00:54:14 -0800 (PST) David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Thu, 19 Feb 2009 15:27:26 -0800
> 
> > eg:
> > 
> > arch/xtensa/include/asm/shmparam.h
> > #define SHMLBA  ((PAGE_SIZE > DCACHE_WAY_SIZE)? PAGE_SIZE : DCACHE_WAY_SIZE)
> > 
> > 
> > But including linux/shm.h here seems a bit silly.   We'll see..
> 
> If DRM even builds on XTENSA, let alone is usable there, I'll
> buy you a lollipop.

heh, OK.  But the risk is there.

<tries to test sparc32 allmodconfig>

scripts/mod/empty.c:1: error: -m64 is not supported by this configuration
scripts/mod/empty.c:1: error: -mlong-double-64 not allowed with -m64
scripts/mod/empty.c:1: error: -mcmodel= is not supported on 32 bit systems

<retires hurt>

