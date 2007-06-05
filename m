Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbXFEMhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbXFEMhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 08:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbXFEMhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 08:37:01 -0400
Received: from raven.upol.cz ([158.194.120.4]:39679 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599AbXFEMhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 08:37:01 -0400
Date: Tue, 5 Jun 2007 14:48:43 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kbuild-devel] [PATCH 08/19] scripts: Make cleanfile/cleanpatch warn about long lines
Message-ID: <20070605124843.GN7266@flower.upol.cz>
References: <20070603204700.GH9240@uranus.ravnborg.org> <20070605073335.GM7266@flower.upol.cz> <20070605081959.GB21991@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605081959.GB21991@uranus.ravnborg.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 10:19:59AM +0200, Sam Ravnborg wrote:
[]
> > So, there are some new scripts. What if my proposition will be better,
> > so to speak? Any problems i'm willing to fix/enhance.
> > 
> > Note: only one copy of the file required. Sym-linked name *diff* or
> > *patch* will process patches. I know, that symlinks in sources isn't
> > good, thus change "$0" -> "$1" will process first parameter.
> 
> Sorry - but I really do not get your point here.
> Are you trying to say that current cleanpatch is not good enough
> or do you propose a new script to do something similar?

Better means, less bloated scripts in the source tree to make
userspace suck less...

> We do not want everyones favorite patch preprocessing script
> in the kernel. So the only option is to incorporate changes in
> cleanpatch.

I don't see scripts/clean* in .21, so decided, to make a hopefully
better, nicer unix-way and posix re-write, this morning.
____
