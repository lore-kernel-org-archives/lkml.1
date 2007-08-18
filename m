Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbXHRSPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbXHRSPH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 14:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbXHRSO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 14:14:57 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:50144 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756452AbXHRSO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 14:14:56 -0400
Date: Sat, 18 Aug 2007 20:14:25 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Olaf Hering <olaf@aepfle.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include linux/types.h in if_fddi.h
Message-ID: <20070818181425.GB32595@stusta.de>
References: <20070809145511.GA8244@aepfle.de> <Pine.LNX.4.64N.0708091654120.3151@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64N.0708091654120.3151@blysk.ds.pg.gda.pl>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 05:36:39PM +0100, Maciej W. Rozycki wrote:
> On Thu, 9 Aug 2007, Olaf Hering wrote:
> 
> > include/linux/if_fddi.h is an exported header.
> > It uses __be16. Include linux/types.h to get this prototype.
> 
>  Please note that for userland it does not matter.  With glibc you should 
> include <netinet/if_fddi.h> which does the necessary bits before including 
> <linux/if_fddi.h>.  Any other C library should likely take a similar 
> approach.

It doesn't make any sense to habe all libc's figure out inter-header 
dependencies.

For each userspace exported header file an #include <linux/foo.h> should 
always compile, and if it fails due to missing #include's in the header 
that's a bug that should be fixed.

>  It still seems right for Linux itself though.
> 
>   Maciej

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

