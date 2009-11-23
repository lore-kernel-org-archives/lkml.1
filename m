Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbZKWXFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbZKWXFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZKWXFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:05:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226AbZKWXFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:05:43 -0500
Date: Mon, 23 Nov 2009 15:05:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       =?ISO-8859-1?Q?An=EDbal?= Monsalve Salazar <anibal@debian.org>,
       Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] kbuild: Steppeing down as Maintainer
Message-Id: <20091123150524.5bd37f6b.akpm@linux-foundation.org>
In-Reply-To: <20091120182613.GA28307@merkur.ravnborg.org>
References: <20091120182249.GA28251@merkur.ravnborg.org>
	<20091120182613.GA28307@merkur.ravnborg.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 19:26:13 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

>  KERNEL BUILD
> -M:	Sam Ravnborg <sam@ravnborg.org>
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next.git
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
>  L:	linux-kbuild@vger.kernel.org
> -S:	Maintained
> +S:	Orphan
>  F:	Documentation/kbuild/
>  F:	Makefile
>  F:	scripts/Makefile.*

Sigh.  Perhaps if I don't apply the patch, this won't happen?

And thanks for all the fish.  I'll continue to scoop up patches as I
see them and shall cc yourself and linux-kbuild and Anibal, Steve and
Michal on them and I shall wait and see what happens.


The current queue is:

kbuild-generate-modulesbuiltin.patch
kbuild-rebuild-fix-for-makefilemodbuiltin.patch
kbuild-generate-modulesbuiltin-fix-2.patch
kbuild-generate-modulesbuiltin-fix-2-checkpatch-fixes.patch
kconfig-cross_compile-option.patch
kbuild-clean-up-marker.patch
kbuild-clear-marker-out-of-modpost.patch
kbuild-genksyms-properly-consider-export_unused_symbol_gpl.patch


If at all possible, please do keep an eye on things as they fly past -
I think we'll find that a few words of insight from you on particular
issues can potentially save others a large amount of work, and can
steer us away from costly mistakes.

Thanks.
