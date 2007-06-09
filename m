Return-Path: <linux-kernel-owner+w=401wt.eu-S1759083AbXFIT0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083AbXFIT0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758161AbXFIT0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:26:08 -0400
Received: from pop-canoe.atl.sa.earthlink.net ([207.69.195.66]:33237 "EHLO
	pop-canoe.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758139AbXFIT0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:26:07 -0400
X-Greylist: delayed 98159 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jun 2007 15:26:07 EDT
From: Rich Chase <rac47.02@engalumni.colostate.edu>
Organization: Independent Thinkers R Us
To: linux-kernel@vger.kernel.org
Subject: Re: missing elfconfig.h
Date: Sat, 9 Jun 2007 12:24:14 -0400
User-Agent: KMail/1.9.4
References: <200706080908.37044.rac47.02@engalumni.colostate.edu> <20070608201947.GD25468@uranus.ravnborg.org>
In-Reply-To: <20070608201947.GD25468@uranus.ravnborg.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706091224.15162.rac47.02@engalumni.colostate.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,
Thanks for the feedback. I need more ideas. See 
responses to your ideas below.

> On Fri, Jun 08, 2007 at 09:08:36AM -0400, Rich Chase 
wrote:
> > An Apparent bug:
> > version 2.6.21.3
> > missing the file ./scripts/mod/elfconfig.h
>
> To build an external module you need to point to a
> directory where a fully build kernel is placed.
>
> You could do a full build and then a "make clean",
> this would still let you build external modules.
>
> In your case the kernel was not build.
> And to build modpost you need to execute "make
> modules" from the kernel top-level directory.
>

Actually, yes, the kernel was fully built, and I had 
booted into it. I had not performed any "make 
mrproper", or anything like that, either. I didn't 
even "make clean".


> > I noticed this when trying to compile a 3rd party
> > module. Maybe this is intended. Not sure.
>
> Anything that is available public?
> Could take a quick look at the Makefile +
> build instructions.
>

Yes, I was attempting to compile gspcav1, a webcam 
driver. It can be found at:
  http://mxhaard.free.fr/download.html

Again, Thanks.
Rich

