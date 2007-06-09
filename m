Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbXFIIwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbXFIIwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbXFIIwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:52:09 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:58830 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbXFIIwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:52:08 -0400
Date: Sat, 9 Jun 2007 10:53:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Rich Chase <rac47.02@engalumni.colostate.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: missing elfconfig.h
Message-ID: <20070609085309.GB30611@uranus.ravnborg.org>
References: <200706080908.37044.rac47.02@engalumni.colostate.edu> <20070608201947.GD25468@uranus.ravnborg.org> <Pine.LNX.4.64.0706090952250.4353@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706090952250.4353@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 09:53:22AM +0200, Jan Engelhardt wrote:
> 
> On Jun 8 2007 22:19, Sam Ravnborg wrote:
> >On Fri, Jun 08, 2007 at 09:08:36AM -0400, Rich Chase wrote:
> >> An Apparent bug:
> >> version 2.6.21.3
> >> missing the file ./scripts/mod/elfconfig.h
> >
> >To build an external module you need to point to a directory
> >where a fully build kernel is placed.
> >
> >You could do a full build and then a "make clean",
> >this would still let you build external modules.
> 
> Is not "make prepare" enough?
> 
> >In your case the kernel was not build.
> >And to build modpost you need to execute "make modules" from
> >the kernel top-level directory.
> 
> "make scripts" ?
It depnes on the module. If the module uses MODVERSIONIGN a full
build is needed.
For the naive case make *config; make prepare; make scripts are enough.
But I encourage a full make and then make clean because that works in
all situations.

	Sam
