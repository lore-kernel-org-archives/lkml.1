Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbZISJGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbZISJGR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbZISJGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:06:16 -0400
Received: from [195.41.46.236] ([195.41.46.236]:37143 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbZISJGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:06:16 -0400
Date: Sat, 19 Sep 2009 11:06:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Caveh Jalali <ecaveh@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] Makefile: can't build modules outside the kernel tree
	if it was built using O=
Message-ID: <20090919090614.GC25877@merkur.ravnborg.org>
References: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 07:30:43PM -0700, Caveh Jalali wrote:
> in 2.6.31, it is no longer possible to build kernel modules for some platforms
> (the ones that need include2) outside the kernel src tree if the
> src tree was built using O= to specify an alternate directory for the
> build output.
> 
> i think this broke with the following commit:
> 
> commit b8b572e1015f81b4e748417be2629dfe51ab99f9
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Fri Aug 1 15:20:30 2008 +1000
> 
>    powerpc: Move include files to arch/powerpc/include/asm
> 
> 
> when the platform specific include directories were shuffled around
> without updating the
> top level Makefile.  however, i think this FAIL is generic, and not
> limited to powerpc.
> here's a patch to the top level Makefile to teach it about the shuffled files:

This is no good. Nothing outside the kernel should in any way rely
on include2. And it will soon be gone anyway.

So we will not try to workaround something that is broken.

	Sam
