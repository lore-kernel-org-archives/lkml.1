Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbXFEITX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbXFEITX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 04:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758367AbXFEITI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 04:19:08 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:38496 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728AbXFEITH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 04:19:07 -0400
Date: Tue, 5 Jun 2007 10:19:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kbuild-devel] [PATCH 08/19] scripts: Make cleanfile/cleanpatch warn about long lines
Message-ID: <20070605081959.GB21991@uranus.ravnborg.org>
References: <20070603204700.GH9240@uranus.ravnborg.org> <20070605073335.GM7266@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605073335.GM7266@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 09:33:35AM +0200, Oleg Verych wrote:
> Hallo.
> 
> On Sun, Jun 03, 2007 at 10:47:00PM +0200, Sam Ravnborg wrote:
> > Subject: [PATCH 08/19] scripts: Make cleanfile/cleanpatch warn about long lines
> > From: H. Peter Anvin <hpa@zytor.com>
> > Date: Fri, 25 May 2007 17:58:26 -0700
> > 
> > Make the "cleanfile" and "cleanpatch" script warn about long lines,
> > by default lines whose visual width exceeds 79 characters.
> > 
> > Per suggestion from Auke Kok.
> > 
> > Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> 
> Thank you, Sam, for sending messages back in Kbuild list again.
> I have ~30k backlog in LKML, so that thing is good.
Delete them all - it only hurst a few minutes ;-)

> 
> So, there are some new scripts. What if my proposition will be better,
> so to speak? Any problems i'm willing to fix/enhance.
> 
> Note: only one copy of the file required. Sym-linked name *diff* or
> *patch* will process patches. I know, that symlinks in sources isn't
> good, thus change "$0" -> "$1" will process first parameter.

Sorry - but I really do not get your point here.
Are you trying to say that current cleanpatch is not good enough
or do you propose a new script to do something similar?

We do not want everyones favorite patch preprocessing script
in the kernel. So the only option is to incorporate changes in
cleanpatch.

If on the other hand you are proposing a script to clean whitespace
damage in the code then git already does this nicely.
I do not recall the actual receipt but searching the git mailing list
should reveal it. So for whitespace cleanup we should use git but maybe
via a small helper script.

	Sam
