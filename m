Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbZIUEZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbZIUEZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 00:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbZIUEZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 00:25:06 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:60422 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZIUEZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 00:25:05 -0400
Date: Mon, 21 Sep 2009 06:25:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] Use macros rather than hardcoding section names
Message-ID: <20090921042506.GA27311@merkur.ravnborg.org>
References: <1253484855-8067-1-git-send-email-tabbott@ksplice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253484855-8067-1-git-send-email-tabbott@ksplice.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 06:14:11PM -0400, Tim Abbott wrote:
> This patch series cleans up the kernel's explicit references to
> .data.page_aligned, .bss.page_aligned, and .data.init_task in C and
> assembly code to instead use the standard macros for that purpose.
> 
> Version 4 differs from version 3 in two ways:
> - It is rebased on top of current kbuild-next/master
> - __LINKER_SCRIPT__ was renamed to LINKER_SCRIPT
> 
> Version 3 differs from version 2 in two ways:
> - The .data.init_task patch also updates the score architecture
> - The powerpc __page_aligned_data patch was removed (since Benjamin
> Herrenschmidt said he was taking it).
> 
> Version 2 differed from version 1 in that it added the kbuild patch,
> fixing breakage in the x86 linker script caused indirectly by
> including linux/linkage.h in x86's asm/cache.h.
> 
> This cleanup is in preparation for being able to change the names of
> the .data.page_aligned and .bss.page_aligned sections to be
> compatible with -ffunction-sections -fdata-sections (a prerequisite
> for Ksplice).
> 
> Joe Perches (1):
>   Use new __init_task_data macro in arch init_task.c files.
> 
> Tim Abbott (3):
>   kbuild: Don't define ALIGN and ENTRY when preprocessing linker
>     scripts.
>   Use macros for .bss.page_aligned section.
>   Use macros for .data.page_aligned section.

Thanks - applied all 4.

	Sam
