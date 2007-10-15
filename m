Return-Path: <linux-kernel-owner+w=401wt.eu-S1764165AbXJOAf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764165AbXJOAf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 20:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbXJOAfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 20:35:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbXJOAfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 20:35:47 -0400
From: Neil Brown <neilb@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 15 Oct 2007 10:35:39 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18194.46555.18395.586488@notabene.brown>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: RFC: reviewer's statement of oversight
In-Reply-To: message from Sam Ravnborg on Tuesday October 9
References: <20071008173706.GA12026@uranus.ravnborg.org>
	<10940.1191883390@lwn.net>
	<18186.50640.970552.719041@notabene.brown>
	<20071009174433.GB25750@uranus.ravnborg.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday October 9, sam@ravnborg.org wrote:
> Hi Neil.
> > 
> >    From:        The Author, Primary Author, or Authors of the patch.
> >                 Authors should also provide a Signed-off-by: tag.
> > 
> >                 Purpose: to give credit to authors
> The SCM should include this info and we should not duplicate this
> in the changelog's.
> I know some tools require this format but that's something else.

If the SCM stores some tags in special places, that is fine with me.
The remove the need for the tag and an understanding of why it exists.
Can 'git' store a list of Authors?  Do we want to allow a list?

> 
> > > +
> > > +Signed-off-by:  A person adding a Signed-off-by tag is attesting that the
> > > +		patch is, to the best of his or her knowledge, legally able
> > > +		to be merged into the mainline and distributed under the
> > > +		terms of the GNU General Public License, version 2.  See
> > > +		the Developer's Certificate of Origin, found in
> > > +		Documentation/SubmittingPatches, for the precise meaning of
> > > +		Signed-off-by.
> > 
> >                 Purpose: to allow subsequent review of the originality of 
> >                 the contribution should copyright questions arise.
> 
> We often use s-o-b to docuemnt the path a patch took from origin (the
> top-most s-o-b) to tree apply (lowest s-o-b).
> This is IIUC part of the intended behaviour of s-o-b but it is not
> clear from the above text.

My understanding of Andrew Morton's position on s-o-b is that it is an
unordered set.  I know this because when I have sent him patches with
a proper From: line, he has complained and begrudingly took the first
s-o-b, but said he didn't like to.
So there seems to be disagreement on this (I think it looks like a
path to - but apparently not to everyone).

> 
> 
> > > +
> > > +Acked-by:	The person named (who should be an active developer in the
> > > +		area addressed by the patch) is aware of the patch and has
> > > +		no objection to its inclusion.  An Acked-by tag does not
> > > +		imply any involvement in the development of the patch or
> > > +		that a detailed review was done.
> > 
> >                 Purpose:  to inform upstream aggregators that
> > 		consensus was achieved for the change.  This is
> > 		particularly relevant for changes that affect multiple
> > 		Maintenance Domains.
> > 
> consensus seems too strong a wording here. consensus imply more than one
> that agree on the patch where I often see people give their "Acked-by:" by
> simple changelog reading.

I'm failing to follow your logic.
You seem to be contrasting:
  "consensus imply more than one that agree"
     which I agree with:  "From" plus all "Acked-By" will be more than
     one in all cases that "Acked-By" is used
with
  "people give their "Acked-by:" by simple changlog reading"
     which I also agree with but this just highlights that "Acked-by"
     is different from "Reviewed-by" 

Confused.

Thanks,
NeilBrown
