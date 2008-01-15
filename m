Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYAOVDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYAOVDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbYAOVDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:03:15 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54350 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYAOVDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:03:14 -0500
Date: Tue, 15 Jan 2008 23:02:11 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Yuusei KUWANA <kuwana@nyanyan.to>
Subject: Re: [PATCH] CRIS v10: vmlinux.lds.S Fix kernel oops on boot and
	use common defines
Message-ID: <20080115210211.GA22064@does.not.exist>
References: <20080115133624.GD3912@axis.com> <20080115123515.126b9cad.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080115123515.126b9cad.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 12:35:15PM -0800, Andrew Morton wrote:
> On Tue, 15 Jan 2008 14:36:24 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> 
> > - Move alignment to page size of init data outside ifdef for BLK_DEV_INITRD.
> >   The reservation up to page size of memory after init data was previously
> >   not done if BLK_DEV_INITRD was undefined.
> >   This caused a kernel oops when init memory pages were freed after startup,
> >   data placed in the same page as the last init memory would also be freed
> >   and reused, with disastrous results.
> 
> So this is a 2.6.24 thing?

The cris architecture does not compile in Linus' tree since 2 or 3 years,
so there shouldn't be any hurry for any cris specific patches.

> > - Use macros for initcalls and .text sections.
> > 
> > - Replace hardcoded page size constant with PAGE_SIZE define.
> > 
> > - Change include/asm-cris/page.h to use the _AC macro to instead
> >   of testing __ASSEMBLY__.
> 
> Even though those are not.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

