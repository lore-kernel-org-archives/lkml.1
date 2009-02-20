Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbZBTIym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbZBTIym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZBTIyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:54:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34913
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbZBTIyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:54:33 -0500
Date: Fri, 20 Feb 2009 00:54:14 -0800 (PST)
Message-Id: <20090220.005414.260531522.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: airlied@linux.ie, benh@kernel.crashing.org,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: Preserve SHMLBA bits in hash key for _DRM_SHM
 mappings.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090219152726.9551fb7a.akpm@linux-foundation.org>
References: <20090218.154102.122148224.davem@davemloft.net>
	<20090219152726.9551fb7a.akpm@linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 19 Feb 2009 15:27:26 -0800

> eg:
> 
> arch/xtensa/include/asm/shmparam.h
> #define SHMLBA  ((PAGE_SIZE > DCACHE_WAY_SIZE)? PAGE_SIZE : DCACHE_WAY_SIZE)
> 
> 
> But including linux/shm.h here seems a bit silly.   We'll see..

If DRM even builds on XTENSA, let alone is usable there, I'll
buy you a lollipop.
