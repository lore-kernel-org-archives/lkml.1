Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbZLNMgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbZLNMgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbZLNMgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:36:41 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54003 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbZLNMgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:36:40 -0500
Date: Mon, 14 Dec 2009 21:36:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Emese Revfy <re.emese@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for 2.6.32-git-053fe57ac v2
Message-ID: <20091214123636.GA7417@linux-sh.org>
References: <cover.1260662994.git.re.emese@gmail.com> <20091214003836.GD7812@parisc-linux.org> <4B2595E7.701@gmail.com> <20091214021916.GB12196@linux-sh.org> <4B25E47C.1010803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B25E47C.1010803@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 08:08:44AM +0100, Emese Revfy wrote:
> Paul Mundt wrote:
> > On Mon, Dec 14, 2009 at 02:33:27AM +0100, Emese Revfy wrote:
> >> Matthew Wilcox wrote:
> >>> On Mon, Dec 14, 2009 at 12:59:08AM +0100, re.emese@gmail.com wrote:
> >>>> The following patch series attempts to constify several structures
> >>>> that hold function pointers. This is only the initial batch, there
> >>>> are about over 150 candidate structures, some of which can be
> >>>> constified as well, I plan to submit them in the future.
> >>> What a complete waste of time.  Until you respond to Al's:
> >> I did: http://lkml.org/lkml/2009/12/5/140
> >>
> >> For even more discussion see: http://lkml.org/lkml/2009/12/6/111
> >>
> > Since you seem to have both the interest and abundance of spare time
> > for working on this, have you considered just doing this in sparse? Al
> > mentioned it here:
> > 
> > 	http://lkml.org/lkml/2009/12/8/511
> > 
> > which you don't seem to have replied to.
> 
> Please see my thoughts on sparse and related topics:
> http://lkml.org/lkml/2009/12/10/283
> 
I don't see anything relating to sparse in that mail. You've effectively
lumped sparse and constification together in the same camp, but it's
unclear why this makes constification a better option other than that
it's simply the option you opted for. All of your arguments "against"
sparse in that context are equally applicable to constification, so I'll
reiterate that you haven't sufficiently addressed the sparse angle.

At present you seem to be the only one convinced that constification is
the way to go, despite it being highly intrusive and ignoring the
potential for more favourable and less intrusive options. You've also
failed to adequately address the issues and suggestsions pointed out by
others, and until this happens there is little point in posting any
follow-up patches.

> > Until such a consensus is reached one way or the other, please refrain
> > from sending hundreds of patches -- one or two are sufficient for showing
> > what you want to do until folks are on board with it, as is the typical
> > nature of mechanical changes.
> 
> I think there is consensus to constify ops variables as much as
> possible (e.g., Alexey's similar patches).
> 
> The discussions in these threads were about constifying the ops structure
> fields themselves and I already explained why they are useful, see the
> above link and this one: http://lkml.org/lkml/2009/12/8/492

And in here as well in the reply to that mail the same criticism exists
as does the suggestion to look at doing it cleanly in sparse, which
brings us back to what was already mentioned earlier.

Thinking you have consensus because you don't see a difference and don't
bother replying to the feedback you've gotten doesn't bode well for the
future of your patch series or killfile avoidance strategy.
