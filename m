Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbYG1V6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbYG1V6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757946AbYG1V6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:58:20 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48380 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757611AbYG1V6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:58:19 -0400
Date: Tue, 29 Jul 2008 00:57:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Eric Miao <eric.miao@marvell.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: bad CONFIG variable references from Makefiles
Message-ID: <20080728215735.GI7713@cs181140183.pp.htv.fi>
References: <alpine.LFD.1.10.0807281607400.28285@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807281607400.28285@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 04:09:28PM -0400, Robert P. J. Day wrote:
> 
>   a complete list of all references to non-existent CONFIG variables
> exclusively from Makefiles in the tree.  since the list is so short,
> i'm not bothering to break it up by subsystem or arch.  enjoy.
>...
> ===== CACHE_XSC3L2 =====
> ./arch/arm/mm/Makefile:obj-$(CONFIG_CACHE_XSC3L2)	+= cache-xsc3l2.o
>...

Comparing commit 20072fd0c93349e19527dd2fa9588b4335960e62
([ARM] pxa: add support for L2 outer cache on XScale3) with
the patch that originally went to linux-arm-kernel it seems
only a tiny fragment of the original patch arrived in the tree.

> rday

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

