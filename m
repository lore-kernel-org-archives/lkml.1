Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbXJIDfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbXJIDfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 23:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXJIDfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 23:35:25 -0400
Received: from main.gmane.org ([80.91.229.2]:40309 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbXJIDfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 23:35:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: RFC: reviewer's statement of oversight
Date: Mon, 8 Oct 2007 20:34:29 -0700
Organization: Linux Foundation
Message-ID: <20071008203429.7c37ee03@freepuppy.rosehill>
References: <20071008173706.GA12026@uranus.ravnborg.org>
	<10940.1191883390@lwn.net>
	<20071008160603.52f9e343.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <20071008160603.52f9e343.randy.dunlap@oracle.com>
X-Newsreader: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2007 16:06:03 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Mon, 08 Oct 2007 16:43:10 -0600 Jonathan Corbet wrote:
> 
> > Sam Ravnborg <sam@ravnborg.org> wrote:
> > 
> > > Or maybe we need something much less formal that explain the purpose of the
> > > four tags we use:
> > 
> > ...or maybe a combination?  How does the following patch look as a way
> > to describe how the tags are used and what Reviewed-by, in particular,
> > means?
> > 
> > Perhaps the DCO should move to this file as well?
> > 
> > jon
> 
> Just typos noted below...
> 
> > ---
> > 
> > Add a document on patch tags.
> > 
> > Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> > 
> > diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
> > index 43e89b1..fa1518b 100644
> > --- a/Documentation/00-INDEX
> > +++ b/Documentation/00-INDEX
> > @@ -284,6 +284,8 @@ parport.txt
> >  	- how to use the parallel-port driver.
> >  parport-lowlevel.txt
> >  	- description and usage of the low level parallel port functions.
> > +patch-tags
> > +	- description of the tags which can be added to patches
> >  pci-error-recovery.txt
> >  	- info on PCI error recovery.
> >  pci.txt
> > diff --git a/Documentation/patch-tags b/Documentation/patch-tags
> > new file mode 100644
> > index 0000000..fb5f8e1
> > --- /dev/null
> > +++ b/Documentation/patch-tags
> > @@ -0,0 +1,66 @@
> > +Patches headed for the mainline may contain a variety of tags documenting
> > +who played a hand in (or was at least aware of) its progress.  All of these
> > +tags have the form:
> > +
> > +	Something-done-by: Full name <email@address>
> > +
> > +These tags are:
> > +
> > +Signed-off-by:  A person adding a Signed-off-by tag is attesting that the
> > +		patch is, to the best of his or her knowledge, legally able
> > +		to be merged into the mainline and distributed under the
> > +		terms of the GNU General Public License, version 2.
All changes are licensed under the terms of the file modified. 

(Some people seem not to understand that
if the file is dual licensed, then the changes are dual licensed. 
If file is GPL v2 only, then the changes are GPL v2 only, ...)

> >  See
> > +		the Developer's Certificate of Origin, found in
> > +		Documentation/SubmittingPatches, for the precise meaning of
> > +		Signed-off-by.


> > +Acked-by:	The person named (who should be an active developer in the
> > +		area addressed by the patch) is aware of the patch and has
> > +		no objection to its inclusion.  An Acked-by tag does not
> > +		imply any involvement in the development of the patch or
> > +		that a detailed review was done.
> > +
> > +Reviewed-by:	The patch has been reviewed and found acceptible according
> 
>                                                       acceptable
> 
> > +		to the Reviewer's Statement as found at the bottom of this
> > +		file.  A Reviewed-by tag is a statement of opinion that the
> > +		patch is an appropriate modification of the kernel without
> > +		any remaining serious technical issues.  Any interested
> > +		reviewer (who has done the work) can offer a Reviewed-by
> > +		tag for a patch.
> > +
> > +Cc:		The person named was given the opportunity to comment on
> > +		the patch.  This is the only tag which might be added
> > +		without an explicit action by the person it names.
> > +
> > +Tested-by:	The patch has been successfully tested (in some
> > +		environment) by the person named.
> > +
>

IMHO the other tags actually are a poor substitute for providing a
more complete description of the reviewer's involvement. It would be better
to have more complete responses like "the patch should be merged as is for
2.6.X but the following should be fixed, ..." etc. The certificate of origin
has meaning for legal things that have a more concrete definition, but the
existing process is about people making good (or bad) decisions based on
feedback and other data. Trying to reduce the feedback down to 3 Acks, and 1 Review
seems like noise. The problem is getting good reviews of new code in
a timely manner, not the descriptions of the result.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>

