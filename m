Return-Path: <linux-kernel-owner+w=401wt.eu-S934202AbXHFPgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202AbXHFPgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934020AbXHFPgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:36:14 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48247
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934002AbXHFPgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:36:11 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Documentation/make/headers_install.txt
Date: Mon, 6 Aug 2007 11:36:02 -0400
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
References: <200708041307.18578.rob@landley.net> <20070804200525.GA21961@uranus.ravnborg.org>
In-Reply-To: <20070804200525.GA21961@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708061036.02604.rob@landley.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 August 2007 3:05:25 pm Sam Ravnborg wrote:
> On Sat, Aug 04, 2007 at 02:07:18PM -0400, Rob Landley wrote:
> > From: Rob Landley <rob@landley.net>
> >
> > Signed-off-by: Rob Landley <rob@landley.net>
> >
> > Some documentation for "make headers_install".
> >
> > ---
> >
> > Earlier discussion was at http://lkml.org/lkml/2007/6/22/7 and I
> > believe I've responded to all of David's comments.
> >
> > --- /dev/null	2007-04-23 10:59:00.000000000 -0500
> > +++ linux-2.6/Documentation/make/headers_install.txt	2007-08-04
> > 13:04:51.000000000 -0500
>
> Any specific reason not to include this in Documentation/kbuild?
> I would prefer to have all kernel build stuff in one directory and
> we have Documentation/kbuild now.

That directory contains internal implementation details of the kernel 
makefiles, and is not about how to use them if you don't plan to modify them.  
This document is about how people can use one of the commands listed in "make 
help", and is not about modifying the make files.  It's a different category 
of documentation.  (Ideally, kbuild would go under make.)

That said, I don't really care where it goes, so if you prefer kbuild I can 
drop it there.  The organization of Documentation/ is fairly irrelevant to me 
at this point.

Like most documentation, this file needs to be linked to from more than one 
place: it needs to be brought to the attention of people building their own 
linux-from-scratch style systems (the "what's in a linux root filesystem" 
section of the index I'm building), it should be linked from a "building the 
kernel" page (what kinds of output can the build produce), there should be 
a "make help" page with hotlinks to the individual commands (like this and 
menuconfig) that have more extensive documentation, etc.

Trying to do that in Documentation would be a pain.  (Lots of symlinks with no 
explanatory text?  Lots of files called "index.txt" in each directory 
reinventing Gopher, pointing you at a directory other than the one you're in 
and hoping nothing ever moves?)

> 	Sam

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
