Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYH0Sta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYH0Sta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYH0StW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:49:22 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:53679 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbYH0StV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ISh+0zAUoIZ3GLbPdj8vX9oJuh/fEc9drt9AMqaLjBxbMxsbdxTAlvKEOHSH6S2m6b
         dkwkR8rKuzRq/10NMVsuKSIl2IunJS29LYAKzE++gWZmVc4r/KxpfkOShsbhoEQHKNQj
         XHQUMFk+dE6JCDxRoHJHEnOCCX6zWUnjEzkBs=
Date: Wed, 27 Aug 2008 22:50:54 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] utrace
Message-ID: <20080827185054.GA30943@x200.localdomain>
References: <20080826220102.89635154233@magilla.localdomain> <20080826223402.GB27724@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826223402.GB27724@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 02:34:02AM +0400, Alexey Dobriyan wrote:
> On Tue, Aug 26, 2008 at 03:01:02PM -0700, Roland McGrath wrote:
> > utrace is a new kernel-side API for kernel modules, intended to make it
> > tractable to work on novel ways to trace and debug user-mode tasks.
> 
> Finally! Familiar code! :^)
> 
> > A previous utrace prototype was in all Fedora kernels since Fedora Core 6.
> > Some substantial implementation and API details in the current code are
> > different from those past versions.
> 
> And some internal details still horrible and overdesigned just like at
> the very beginning.
> 
> > Please look freshly at these patches.
> 
> Well, all comments on tracehook patches were ignored.
> 
> > This code cannot be enabled without CONFIG_HAVE_ARCH_TRACEHOOK and the arch
> > details it indicates.  In Linus's tree as of v2.6.27-rc4, only powerpc and
> > sparc64 have that support.  The x86 support is available by merging in the
> > tip/x86/tracehook branch.  For working on other arch support, there are some
> > more details at http://sourceware.org/systemtap/wiki/utrace/arch/HowTo and
> > these are mentioned in the comments in arch/Kconfig too (in v2.6.27-rc4).
> > 
> > The first patch adds the utrace kernel API (if CONFIG_UTRACE=y is set).
> > There is no change at all without the config option, and with it there is
> > no effect on anything at all until a kernel module using the utrace API is
> > loaded.  There is detailed documentation on the API in DocBook form.
> > 
> > The second patch adds the CONFIG_UTRACE_PTRACE option.
> 
> If config option for ptrace is fine, please name it CONFIG_PTRACE.
> For one, there will be no second tracing infrastracture. For two, nobody
> but one man on the planet really cares how ptrace(2) is implemented.

Oh, I totally misread what this potion is about.

Of course, it shouldn't exist at all.

