Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbYBQTfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbYBQTfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYBQTfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:35:07 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:49390 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbYBQTfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:35:05 -0500
Date: Sun, 17 Feb 2008 20:35:14 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: 2.6.25-rc2 vdso_install breaks user "make install"
Message-ID: <20080217193514.GJ14588@uranus.ravnborg.org>
References: <47B6592A.6030200@keyaccess.nl> <20080216034211.8DD03270193@magilla.localdomain> <20080216113610.GB11362@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216113610.GB11362@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 12:36:10PM +0100, Sam Ravnborg wrote:
> On Fri, Feb 15, 2008 at 07:42:11PM -0800, Roland McGrath wrote:
> > Perhaps it makes more sense to have vdso_install be a dependency of
> > modules_install rather than install, since they both put things in /lib/modules.
> > The installed vdso images are potentially useful for a kernel when you
> > aren't bothering to build or install any modules, but those images are only
> > ever useful for sophisticated debugging uses anyway.
> > 
> > Sam, any thoughts?  (See arch/x86/Makefile and arch/powerpc/Makefile.)
> 
> Installing the vdso files as aprt of modules_install would be
> unintuitive as this has nothing to do with modules.
> 
> And since you wrote:
> > useful for sophisticated debugging uses anyway
> I suggest to make the vdso_install step independent as
> in following patch.
> [Note: help docs needs to mention the new target].
> 
> This solves the issue at ahnd and still gives us the posibility
> to install the files should they be needed.

Roland - if you agree will you please submit the patch
to the x86 people.
You can tag it:
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
or Acked-by: Sam Ravnborg <sam@ravnborg.org>

as you like.

	Sam
