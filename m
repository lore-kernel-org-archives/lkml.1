Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbXFIIyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbXFIIyK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbXFIIx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:53:57 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59037 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbXFIIx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:53:57 -0400
Date: Sat, 9 Jun 2007 10:54:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Rich Chase <rac47.02@engalumni.colostate.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: missing elfconfig.h
Message-ID: <20070609085459.GC30611@uranus.ravnborg.org>
References: <200706080908.37044.rac47.02@engalumni.colostate.edu> <20070608201947.GD25468@uranus.ravnborg.org> <Pine.LNX.4.64.0706090952250.4353@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0706090355150.11073@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706090355150.11073@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 03:57:30AM -0400, Robert P. J. Day wrote:
> On Sat, 9 Jun 2007, Jan Engelhardt wrote:
> 
> >
> > On Jun 8 2007 22:19, Sam Ravnborg wrote:
> > >On Fri, Jun 08, 2007 at 09:08:36AM -0400, Rich Chase wrote:
> > >> An Apparent bug:
> > >> version 2.6.21.3
> > >> missing the file ./scripts/mod/elfconfig.h
> > >
> > >To build an external module you need to point to a directory
> > >where a fully build kernel is placed.
> > >
> > >You could do a full build and then a "make clean",
> > >this would still let you build external modules.
> >
> > Is not "make prepare" enough?
> 
> technically, you want to run "make modules_prepare" on the tree, after
> doing a configuration.

Yep - had forgotten about that target.
Was you btw. planning to write up a kbuild HOWTO one day?

It would be nice to point to some kind of docs for such questions.

	Sam
