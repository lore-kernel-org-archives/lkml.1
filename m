Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbYAONyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbYAONyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbYAONyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:54:15 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46969 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbYAONyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:54:14 -0500
Date: Tue, 15 Jan 2008 14:54:19 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org,
       Yuusei KUWANA <kuwana@nyanyan.to>
Subject: Re: [PATCH] CRIS v10: vmlinux.lds.S Fix kernel oops on boot and use common defines
Message-ID: <20080115135419.GA17685@uranus.ravnborg.org>
References: <20080115133624.GD3912@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115133624.GD3912@axis.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 02:36:24PM +0100, Jesper Nilsson wrote:
> - Move alignment to page size of init data outside ifdef for BLK_DEV_INITRD.
>   The reservation up to page size of memory after init data was previously
>   not done if BLK_DEV_INITRD was undefined.
>   This caused a kernel oops when init memory pages were freed after startup,
>   data placed in the same page as the last init memory would also be freed
>   and reused, with disastrous results.
> 
> - Use macros for initcalls and .text sections.
> 
> - Replace hardcoded page size constant with PAGE_SIZE define.
> 
> - Change include/asm-cris/page.h to use the _AC macro to instead
>   of testing __ASSEMBLY__.

Looks good.

What about applying the same fixes/changes to v32?

It would btw. be nice to move the vmlinux.lds.S files to
arch/cris/kernel/.
Se how x86 handle build for two different bit sizes.

If this is done then cris is less awkward compared
to the other archs.

	Sam
