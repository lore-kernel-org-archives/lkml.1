Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbXJIRnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbXJIRnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbXJIRnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:43:04 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40954 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbXJIRnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:43:03 -0400
Date: Tue, 9 Oct 2007 19:44:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Neil Brown <neilb@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: RFC: reviewer's statement of oversight
Message-ID: <20071009174433.GB25750@uranus.ravnborg.org>
References: <20071008173706.GA12026@uranus.ravnborg.org> <10940.1191883390@lwn.net> <18186.50640.970552.719041@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18186.50640.970552.719041@notabene.brown>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil.
> 
>    From:        The Author, Primary Author, or Authors of the patch.
>                 Authors should also provide a Signed-off-by: tag.
> 
>                 Purpose: to give credit to authors
The SCM should include this info and we should not duplicate this
in the changelog's.
I know some tools require this format but that's something else.

> > +
> > +Signed-off-by:  A person adding a Signed-off-by tag is attesting that the
> > +		patch is, to the best of his or her knowledge, legally able
> > +		to be merged into the mainline and distributed under the
> > +		terms of the GNU General Public License, version 2.  See
> > +		the Developer's Certificate of Origin, found in
> > +		Documentation/SubmittingPatches, for the precise meaning of
> > +		Signed-off-by.
> 
>                 Purpose: to allow subsequent review of the originality of 
>                 the contribution should copyright questions arise.

We often use s-o-b to docuemnt the path a patch took from origin (the
top-most s-o-b) to tree apply (lowest s-o-b).
This is IIUC part of the intended behaviour of s-o-b but it is not
clear from the above text.


> > +
> > +Acked-by:	The person named (who should be an active developer in the
> > +		area addressed by the patch) is aware of the patch and has
> > +		no objection to its inclusion.  An Acked-by tag does not
> > +		imply any involvement in the development of the patch or
> > +		that a detailed review was done.
> 
>                 Purpose:  to inform upstream aggregators that
> 		consensus was achieved for the change.  This is
> 		particularly relevant for changes that affect multiple
> 		Maintenance Domains.
> 
consensus seems too strong a wording here. consensus imply more than one
that agree on the patch where I often see people give their "Acked-by:" by
simple changelog reading.
So Acked-by: is not used like documented today.

	Sam
