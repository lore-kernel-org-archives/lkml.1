Return-Path: <linux-kernel-owner+w=401wt.eu-S1759403AbXJOObW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbXJOObW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 10:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbXJOObN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 10:31:13 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50248 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbXJOObM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 10:31:12 -0400
Date: Mon, 15 Oct 2007 16:32:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Neil Brown <neilb@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: RFC: reviewer's statement of oversight
Message-ID: <20071015143239.GA21361@uranus.ravnborg.org>
References: <20071008173706.GA12026@uranus.ravnborg.org> <10940.1191883390@lwn.net> <18186.50640.970552.719041@notabene.brown> <20071009174433.GB25750@uranus.ravnborg.org> <18194.46555.18395.586488@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18194.46555.18395.586488@notabene.brown>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 10:35:39AM +1000, Neil Brown wrote:
> On Tuesday October 9, sam@ravnborg.org wrote:
> > Hi Neil.
> > > 
> > >    From:        The Author, Primary Author, or Authors of the patch.
> > >                 Authors should also provide a Signed-off-by: tag.
> > > 
> > >                 Purpose: to give credit to authors
> > The SCM should include this info and we should not duplicate this
> > in the changelog's.
> > I know some tools require this format but that's something else.
> 
> If the SCM stores some tags in special places, that is fine with me.
> The remove the need for the tag and an understanding of why it exists.
> Can 'git' store a list of Authors?  Do we want to allow a list?
git stores to my best knowledge only a single author.
Infrequently we need a list but then people have solved it putting
relevant people in s-o-b and by give credit in changelog.
This is IMHO good enugh.

> 
> > 
> > > > +
> > > > +Signed-off-by:  A person adding a Signed-off-by tag is attesting that the
> > > > +		patch is, to the best of his or her knowledge, legally able
> > > > +		to be merged into the mainline and distributed under the
> > > > +		terms of the GNU General Public License, version 2.  See
> > > > +		the Developer's Certificate of Origin, found in
> > > > +		Documentation/SubmittingPatches, for the precise meaning of
> > > > +		Signed-off-by.
> > > 
> > >                 Purpose: to allow subsequent review of the originality of 
> > >                 the contribution should copyright questions arise.
> > 
> > We often use s-o-b to docuemnt the path a patch took from origin (the
> > top-most s-o-b) to tree apply (lowest s-o-b).
> > This is IIUC part of the intended behaviour of s-o-b but it is not
> > clear from the above text.
> 
> My understanding of Andrew Morton's position on s-o-b is that it is an
> unordered set.  I know this because when I have sent him patches with
> a proper From: line, he has complained and begrudingly took the first
> s-o-b, but said he didn't like to.
> So there seems to be disagreement on this (I think it looks like a
> path to - but apparently not to everyone).
With the current definition you need to supply BOTH a from: and a s-o-b.
I usually request a s-o-b when it is missing no matter what other content 
is present in the changelog.

> 
> > 
> > 
> > > > +
> > > > +Acked-by:	The person named (who should be an active developer in the
> > > > +		area addressed by the patch) is aware of the patch and has
> > > > +		no objection to its inclusion.  An Acked-by tag does not
> > > > +		imply any involvement in the development of the patch or
> > > > +		that a detailed review was done.
> > > 
> > >                 Purpose:  to inform upstream aggregators that
> > > 		consensus was achieved for the change.  This is
> > > 		particularly relevant for changes that affect multiple
> > > 		Maintenance Domains.
> > > 
> > consensus seems too strong a wording here. consensus imply more than one
> > that agree on the patch where I often see people give their "Acked-by:" by
> > simple changelog reading.
> 
> I'm failing to follow your logic.
> You seem to be contrasting:
>   "consensus imply more than one that agree"
>      which I agree with:  "From" plus all "Acked-By" will be more than
>      one in all cases that "Acked-By" is used
I did not realise that "concensus" in this context refered to both the
one that give the "Acked-by" and the author.
Viewing it this way I agree with the intent and the text.

	Sam
