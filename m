Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbXESIUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbXESIUS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 04:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbXESIUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 04:20:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:38046 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbXESIUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 04:20:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TJLBhW2QPh+3PiqP4nchtz2Wq1IesIiNx7IsaA6GDfOgMBgxsp56T42snV5FpLJ7fg7N8wkfWd0kFlegg6e7oJIrdX0Wihf8IBuVFMUPW57SA9kiGDVdt+UepmeVXkVChPMwKru4c0wc+WjFXLxKjsSan3L1ReISJm7GbdXl4T0=
Date: Sat, 19 May 2007 12:18:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Richard Henderson <rth@twiddle.net>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ALPHA: MARVEL - check for allocated memory
Message-ID: <20070519081851.GA8288@cvg>
References: <20070516181214.GA16348@cvg> <20070516114455.c0ee691e.akpm@linux-foundation.org> <20070517143712.GA8991@cvg> <20070517103113.107f4363.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517103113.107f4363.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrew Morton - Thu, May 17, 2007 at 10:31:13AM -0700]
| On Thu, 17 May 2007 18:37:12 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > [Andrew Morton - Wed, May 16, 2007 at 11:44:55AM -0700]
| > | On Wed, 16 May 2007 22:12:14 +0400
| > | Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > | 
| > | > This patch adds checking for allocated memory
| > | > which is used to hold AGP info. Also some whitespace
| > | > cleanup.
| > | 
| > | The inclusion of all the whitespace fixies makes it rather hard to
| > | see what the patch actually does.
| > | 
| > | I'm not sure that I can be bothered with this, really.  afaict the
| > | checks you're adding are for boot-time allocations which we tend
| > | to assume won't fail, and they're kmalloc(small-amount, GFP_KERNEL)
| > | which is basically infallible, and it only affects, err, alpha.
| > | 
| > 
| > So you think we could leave all as is? I mean sould I just drop the patch?
| 
| mutter.  I spose we should fix those sites which can be called at times other than
| system boot.  Often one can use the lack of __init annotation to work out if a site
| is being called after boot.
| 

Hi Andrew,

you know as I see marvel and titan (they are touched by my patches) only uses
kmalloc at boot time (as you mentoined) and there are no sites with unchecked
kmalloc calls after booting. So just forget about patches I sent ;)

		Cyrill

