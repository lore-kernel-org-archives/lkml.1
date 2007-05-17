Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbXEQOiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbXEQOiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXEQOiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:38:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:19415 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbXEQOiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:38:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=XuTuLQXS29Ot/Cq0Vg4lopF3peDmlwKM3I1WmS8O4eC+RP5AOF2HyecQ3X6ff+OGCwv2g40nM3nkwOwSftUdQ8FR5TmkhzYzK3kyFBaCHqzdPCbM0aaDHxe5OnHbvhrWF6in57x70/XFG1TeAfxPr5CRc5Hk4ZAk7BEq3ff0JBI=
Date: Thu, 17 May 2007 18:37:12 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Richard Henderson <rth@twiddle.net>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ALPHA: MARVEL - check for allocated memory
Message-ID: <20070517143712.GA8991@cvg>
References: <20070516181214.GA16348@cvg> <20070516114455.c0ee691e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516114455.c0ee691e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrew Morton - Wed, May 16, 2007 at 11:44:55AM -0700]
| On Wed, 16 May 2007 22:12:14 +0400
| Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > This patch adds checking for allocated memory
| > which is used to hold AGP info. Also some whitespace
| > cleanup.
| 
| The inclusion of all the whitespace fixies makes it rather hard to
| see what the patch actually does.
| 
| I'm not sure that I can be bothered with this, really.  afaict the
| checks you're adding are for boot-time allocations which we tend
| to assume won't fail, and they're kmalloc(small-amount, GFP_KERNEL)
| which is basically infallible, and it only affects, err, alpha.
| 

So you think we could leave all as is? I mean sould I just drop the patch?

		Cyrill

