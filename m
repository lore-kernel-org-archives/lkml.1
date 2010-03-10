Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab0CJOiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:38:15 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:48026 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab0CJOiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:38:13 -0500
Date: Wed, 10 Mar 2010 15:38:10 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: smatch_scripts/whitespace_only.sh
In-Reply-To: <20100310142759.GG6321@bicker>
Message-ID: <Pine.LNX.4.64.1003101537040.27249@ask.diku.dk>
References: <20100310101224.GC6321@bicker> <Pine.LNX.4.64.1003101113330.24684@ask.diku.dk>
 <20100310142759.GG6321@bicker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010, Dan Carpenter wrote:

> On Wed, Mar 10, 2010 at 11:14:53AM +0100, Julia Lawall wrote:
> > On Wed, 10 Mar 2010, Dan Carpenter wrote:
> > 
> > > I wrote a script to check that a patch only changes white space.
> > > It compiles the files before and after the patch is applied and 
> > > verifies that they are the same.
> > > 
> > > You'll need to compile smatch:
> > > 	git pull git://repo.or.cz/smatch.git
> > > 	make
> > > 	cd /path/to/kernel/src/
> > > 	/path/to/smatch_scripts/whitespace_only.sh <patch>
> > > 
> > > Adding or removing parenthesis and curly braces counts as a code 
> > > change.  Changes to comments, #if 0, white space changes do not.
> > > 
> > > You can fix a lot of style violations if you limit yourself to 
> > > adding and removing tabs, spaces and new lines.  Then the next 
> > > patch could remove unneeded parenthesis.  It would be easier to
> > > audit that way instead of everything mixed together.
> > > 
> > > regards,
> > > dan carpenter
> > > 
> > > PS.  I feel really bad slagging the newbies trying to help.  
> > > Could we fix checkpatch.pl to not complain about line lengths?
> > 
> > I hope not...  Are newbies really put off by having to add a newline here 
> > and there?
> > 
> > julia
> > 
> 
> The problem is that newbies are only too happy to chop lines up into smaller 
> and smaller bits.  :P  I've seen situations where the actual author of the code
> broke up _his own_ perfectly reasonable code into tiny chunks just to satisfy 
> checkpatch.pl.
> 
> 				printk("blah blah blah blah"
> 						"blah blah"
> 						"blah");
> 
> It would be great if people dealt with checkpatch warnings by breaking
> things out into separate functions and eliminating indent levels but 
> that never happens.

Maybe checkpatch could be changed to not complain about > 80 characters 
when the line contains a string?

julia
