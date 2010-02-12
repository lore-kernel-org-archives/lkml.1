Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab0BLSyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 13:54:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:51418 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab0BLSyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 13:54:39 -0500
Date: Fri, 12 Feb 2010 16:53:58 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: mingo@redhat.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       hpa@zytor.com, efault@gmx.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf top: Fix annotate for userspace
Message-ID: <20100212185358.GD8589@ghostprotocols.net>
References: <1265550376-12665-1-git-send-email-acme@infradead.org> <tip-ee11b90b12eb1ec25e1044bac861e90bfd19ec9e@git.kernel.org> <20100212162059.GA30041@landau.phys.spbu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100212162059.GA30041@landau.phys.spbu.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 12, 2010 at 07:20:59PM +0300, Kirill Smelkov escreveu:
> On Sun, Feb 07, 2010 at 04:33:40PM +0000, tip-bot for Kirill Smelkov wrote:
> > Commit-ID:  ee11b90b12eb1ec25e1044bac861e90bfd19ec9e
> > Gitweb:     http://git.kernel.org/tip/ee11b90b12eb1ec25e1044bac861e90bfd19ec9e
> > Author:     Kirill Smelkov <kirr@landau.phys.spbu.ru>
> > AuthorDate: Sun, 7 Feb 2010 11:46:15 -0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sun, 7 Feb 2010 17:30:20 +0100
> > 
> > perf top: Fix annotate for userspace
> 
> [...]
> 
> Arnaldo, Ingo, thanks for finally applying it
> 
>   ( though shouldn't, AuthorDate be ``Fri,  8 Jan 2010 15:23:08 +0300'',
>     just like in my post for this patch
>     http://marc.info/?l=linux-kernel&m=126295508002536&w=2 ?)
> 
> ----
> 
> Also, could you please apply one last cosmetic patch from my original
> series
> 
> http://marc.info/?l=linux-kernel&m=126295502702502&w=2
> 
> 
> That would logically complete my holiday journey to perf land.
> 
> 
> For convenience I'm providing this one last patch here (applies to
> tip/master cleanly).

Ingo, you may take this one now or wait till my next series, your
choice,

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
 
> Thanks beforehand,
> Kirill
> 
> 
> From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
> Subject: [PATCH 2/6] perf top: align help text on keys
> Date: Fri,  8 Jan 2010 15:23:05 +0300
> 
> Mapped keys:
>         [d]     display refresh delay.                  (2)
>         [e]     display entries (lines).                (46)
>         [f]     profile display filter (count).         (5)
>         [F]     annotate display filter (percent).      (5%)
>         [s]     annotate symbol.                        (NULL)
>         [S]     stop annotation.
>         [K]     hide kernel_symbols symbols.            (no)
>         [U]     hide user symbols.                      (no)
>         [z]     toggle sample zeroing.                  (0)
>         [qQ]    quit.
> 
> instead of
> 
> Mapped keys:
>         [d]     display refresh delay.                  (2)
>         [e]     display entries (lines).                (46)
>         [f]     profile display filter (count).         (5)
>         [F]     annotate display filter (percent).      (5%)
>         [s]     annotate symbol.                        (NULL)
>         [S]     stop annotation.
>         [K]     hide kernel_symbols symbols.                    (no)
>         [U]     hide user symbols.                      (no)
>         [z]     toggle sample zeroing.                  (0)
>         [qQ]    quit.
> 
> Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
> ---
>  tools/perf/builtin-top.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 9c7de93..9dc8070 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -704,7 +704,7 @@ static void print_mapped_keys(void)
>  		fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", display_weighted ? 1 : 0);
>  
>  	fprintf(stdout,
> -		"\t[K]     hide kernel_symbols symbols.             \t(%s)\n",
> +		"\t[K]     hide kernel_symbols symbols.     \t(%s)\n",
>  		hide_kernel_symbols ? "yes" : "no");
>  	fprintf(stdout,
>  		"\t[U]     hide user symbols.               \t(%s)\n",
> -- 
> 1.6.6.79.gd514e.dirty
