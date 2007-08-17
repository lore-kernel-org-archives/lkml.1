Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbXHQOrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbXHQOrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 10:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbXHQOrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 10:47:11 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60892 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbXHQOrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 10:47:09 -0400
Date: Fri, 17 Aug 2007 16:48:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Joe Perches <joe@perches.com>
Cc: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: RFHelp:  Splitting MAINTAINERS into maintainers/* and	Makefile/Kconfig support
Message-ID: <20070817144827.GB20963@uranus.ravnborg.org>
References: <1187297496.5906.113.camel@localhost> <46C53F3F.5060108@redhat.com> <1187353841.822.60.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1187353841.822.60.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe.

> > Perhaps with a little automation it could be revived,
> 
> Which is the help I'm looking for.
> 
> Can someone please help here on ideas or implementation
> adding a makefile target for MAINTAINERS from files
> in a specific subdirectory?

Adding a specific target på top-level Makefile is easy to
do so I assume you are looking for something more advanced?

And that part "more advanced" I do not know what is.
It is easy to traverse the tree and build up a file
and I think the easies is to do so in perl or similar.

Doing so using the normal kbuild machinery is not soo
good since it will be parallel and we want something serail
here.

If you define how the Maintainer info is stored we can work
out something.

	Sam
