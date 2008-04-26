Return-Path: <linux-kernel-owner+w=401wt.eu-S1762258AbYDZTsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762258AbYDZTsm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759586AbYDZTsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:48:33 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:40313 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759196AbYDZTsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:48:32 -0400
Date: Sat, 26 Apr 2008 21:49:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [GIT PULL] kbuild fixes
Message-ID: <20080426194904.GB9131@uranus.ravnborg.org>
References: <20080426191256.GA784@uranus.ravnborg.org> <20080426192037.GR2252@cs181133002.pp.htv.fi> <20080426193701.GA9131@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426193701.GA9131@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 09:37:01PM +0200, Sam Ravnborg wrote:
> On Sat, Apr 26, 2008 at 10:20:37PM +0300, Adrian Bunk wrote:
> > On Sat, Apr 26, 2008 at 09:12:56PM +0200, Sam Ravnborg wrote:
> > > Hi Linus.
> > > 
> > > Please apply the following two fixes by pulling from:
> > > 
> > >    master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git
> > > 
> > > 
> > > The MODULE_LICENSE fix is neded to get an allmodconfig
> > > build fixed.
> > 
> > Which one is this?
> > 
> > http://lkml.org/lkml/2008/3/31/50 ?
> > (my allmod build is not yet finished)
> 
> The changelog was actually bad for this one.
> I saw two classes of problems:
> 
> 1) I got report about broken builds - fbdev was the culprint.
> 2) a "make CONFIG_DEBUG_SECTION_MISMATCH=y" build broke
>    immediately.
> 
> I made it non-fatal because we had at least one module that
> was not yet fixed.
And by the way - had this been in -mm/-next as it ought to
be we wuld know the eventual breakage it would have caused.
But I have been a lousy maintainer the last months so that
did not happen as it should and the MODULE_LICENSE
thing went straight to -linus.

	Sam
