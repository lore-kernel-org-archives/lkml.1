Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbXEXUcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbXEXUcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbXEXUbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:31:53 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33717 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbXEXUbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:31:53 -0400
Date: Thu, 24 May 2007 22:32:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       kbuild-devel@lists.sourceforge.net
Subject: Re: [rfe] easier customization of kconfig for non-Linux projects
Message-ID: <20070524203252.GB1372@uranus.ravnborg.org>
References: <200705240117.39800.vapier@gentoo.org> <20070524064004.GA28923@uranus.ravnborg.org> <200705240923.42035.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705240923.42035.vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 09:23:40AM -0400, Mike Frysinger wrote:
> On Thursday 24 May 2007, Sam Ravnborg wrote:
> > The intent with this is clear but the solution you suggest albeit simple
> > does not really match where we could end up with kconfig.
> > Recently Roman added support for options in the kconfig language
> > and I would assume we could deal with most of this just using options.
> 
> that certainly sounds nicer :)
> 
> > One example could be to support options for the mainmenu entrye like this:
> >
> > mainmenu "Busybow config system"
> > 	option project="Busybox"
> > 	option version="$VERSION"   <= Where '$' signify an environment variable
> 
> this is doable now ?  if so, i'll test it out in uClibc ...
No - it was just a proposal.
Would like to have a word from Roman before looking deeper into it.

	Sam
