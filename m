Return-Path: <linux-kernel-owner+w=401wt.eu-S970921AbXFHUSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970921AbXFHUSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759837AbXFHUSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:18:46 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60478 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbXFHUSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:18:46 -0400
Date: Fri, 8 Jun 2007 22:19:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rich Chase <rac47.02@engalumni.colostate.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: missing elfconfig.h
Message-ID: <20070608201947.GD25468@uranus.ravnborg.org>
References: <200706080908.37044.rac47.02@engalumni.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706080908.37044.rac47.02@engalumni.colostate.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 09:08:36AM -0400, Rich Chase wrote:
> An Apparent bug:
> version 2.6.21.3
> missing the file ./scripts/mod/elfconfig.h

To build an external module you need to point to a directory
where a fully build kernel is placed.

You could do a full build and then a "make clean",
this would still let you build external modules.

In your case the kernel was not build.
And to build modpost you need to execute "make modules" from
the kernel top-level directory.

> I noticed this when trying to compile a 3rd party 
> module. Maybe this is intended. Not sure.
Anything that is available public?
Could take a quick look at the Makefile +
build instructions.

	Sam
