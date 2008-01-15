Return-Path: <linux-kernel-owner+w=401wt.eu-S1751694AbYAOOXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbYAOOXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 09:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbYAOOXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 09:23:24 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:51605 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbYAOOXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 09:23:23 -0500
Date: Tue, 15 Jan 2008 15:23:00 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org,
       Yuusei KUWANA <kuwana@nyanyan.to>
Subject: Re: [PATCH] CRIS v10: vmlinux.lds.S Fix kernel oops on boot and use common defines
Message-ID: <20080115142300.GE3912@axis.com>
References: <20080115133624.GD3912@axis.com> <20080115135419.GA17685@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115135419.GA17685@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 02:54:19PM +0100, Sam Ravnborg wrote:
> On Tue, Jan 15, 2008 at 02:36:24PM +0100, Jesper Nilsson wrote:
> > - Move alignment to page size of init data outside ifdef for BLK_DEV_INITRD.
> >   The reservation up to page size of memory after init data was previously
> >   not done if BLK_DEV_INITRD was undefined.
> >   This caused a kernel oops when init memory pages were freed after startup,
> >   data placed in the same page as the last init memory would also be freed
> >   and reused, with disastrous results.
> > 
> > - Use macros for initcalls and .text sections.
> > 
> > - Replace hardcoded page size constant with PAGE_SIZE define.
> > 
> > - Change include/asm-cris/page.h to use the _AC macro to instead
> >   of testing __ASSEMBLY__.
> 
> Looks good.

Thanks.

> What about applying the same fixes/changes to v32?

In the works.

> It would btw. be nice to move the vmlinux.lds.S files to
> arch/cris/kernel/.
> Se how x86 handle build for two different bit sizes.
> 
> If this is done then cris is less awkward compared
> to the other archs.

That's a really good idea. I'll add that to my todo-list.

> 	Sam

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
