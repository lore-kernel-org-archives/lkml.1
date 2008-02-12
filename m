Return-Path: <linux-kernel-owner+w=401wt.eu-S1760809AbYBLTg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809AbYBLTg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYBLTgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:36:49 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:56991 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbYBLTgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:36:48 -0500
Date: Tue, 12 Feb 2008 20:36:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: vmsplice exploits, stack protector and Makefiles
Message-ID: <20080212193655.GA2771@uranus.ravnborg.org>
References: <20080212090001.3fcc4ca0@laptopd505.fenrus.org> <20080212185012.GA2348@uranus.ravnborg.org> <20080212110818.62496cf4@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212110818.62496cf4@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 11:08:18AM -0800, Arjan van de Ven wrote:
> On Tue, 12 Feb 2008 19:50:12 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> > > 
> > > Now I realize that certain distros have patched gcc to compensate
> > > for their lack of distro wide CFLAGS, and it's great to work around
> > > that... but would there be a way to NOT disable this for
> > > CONFIG_CC_STACKPROTECTOR please? It would have made this exploit
> > > not possible for those kernels that enable this feature (and that
> > > includes distros like Fedora)
> > 
> > I guess the problem is that we in arch/x86/Makefile enable the
> > stackprotector but then later in the main Makefile disables it.
> > So the right way to approach this should be to always disable it and
> > the reenable it in the arch Makefile.
> > So something like this?
> 
> 
> the patch works fine for me.
> Linus, can we please get this merged into .25? it will at least
> again limit the damage exploits like the vmsplice one can do..
> 
> (I think it's also worth it for -stable)

I will prepare it for my next -fix round. Due in a few days.

	Sam

