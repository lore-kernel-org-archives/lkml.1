Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbXHaQ3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbXHaQ3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 12:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759315AbXHaQ3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 12:29:24 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56937 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759093AbXHaQ3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 12:29:23 -0400
Date: Fri, 31 Aug 2007 18:30:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Valdis.Kletnieks@vt.edu
Cc: Adrian Bunk <bunk@kernel.org>, Oliver Neukum <oliver@neukum.org>,
       linux-kernel@vger.kernel.org
Subject: Re: possible build system oddity
Message-ID: <20070831163044.GA29304@uranus.ravnborg.org>
References: <200708311037.29280.oliver@neukum.org> <20070831084229.GE9260@stusta.de> <26547.1188572427@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26547.1188572427@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 11:00:27AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 31 Aug 2007 10:42:29 +0200, Adrian Bunk said:
> > On Fri, Aug 31, 2007 at 10:37:28AM +0200, Oliver Neukum wrote:
> > > Hi,
> > > 
> > > I only touched sound/usb/usbaudio.c
> > > Nevertheless the whole subtree und sound/ is recompiling. What's
> > > happening?
> > 
> > The only file that gets compiled (CC) should be sound/usb/usbaudio.c
> > 
> > It seems you are confused by the fact that this recompilation results in 
> > several relinks (LD)?
> 
> Or something else changed that he didn't realize.  Just the other day, I
> applied a one-line patch that hit one .c file, and *the entire kernel*
> started rebuilding.
> 
> Took me a while to figure out that I'd been looking for something else, and
> done a 'vi Makefile' in the top level, and exited with 'ZZ' rather than ':q' ;)

That should not result in a full rebuild, but you would see at least stuff in
kernel/ being compiled.

kbuild try to track all dependencies and sometimes people have a few suprises.
But the important part is that people *trust* that kbuild does the right thing
when they touch something - and so it is these days.

	Sam
