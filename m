Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbYDNXaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbYDNXaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 19:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYDNXaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 19:30:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755035AbYDNXaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 19:30:09 -0400
Date: Mon, 14 Apr 2008 16:29:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: ralf@linux-mips.org, linux-kernel@vger.kernel.org, sam@ravnborg.org,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Pageflags: Standardize comment inclusion in asm-offsets.h and
 fix MIPS
Message-Id: <20080414162924.da6360a4.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0804141456410.8740@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0804141140430.7154@schroedinger.engr.sgi.com>
	<20080414133213.82a5b76e.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0804141456410.8740@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 14:58:14 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> powerpc allmodconfig is still
> > unwell:
> > 
> >   CC      arch/powerpc/kernel/asm-offsets.s
> > In file included from include/linux/gfp.h:4,
> >                  from include/linux/slab.h:14,
> >                  from include/linux/percpu.h:5,
> >                  from include/asm/time.h:18,
> >                  from include/asm/cputime.h:26,
> >                  from include/linux/sched.h:67,
> >                  from arch/powerpc/kernel/asm-offsets.c:17:
> > include/linux/mmzone.h:830:2: error: #error Allocator MAX_ORDER exceeds SECTION_SIZE
> 
> Cannot figure out what this has to do with page flags.

Nothing at all.  It was silly of you to think so :)

> AFACIT the powerpc 
> config is borked because section size is set too low for 64K pages.

Yes, the above allmodconfig error was caused by git-powerpc.
