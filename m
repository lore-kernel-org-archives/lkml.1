Return-Path: <linux-kernel-owner+w=401wt.eu-S1762432AbYEEVM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762432AbYEEVM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762157AbYEEVMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:12:00 -0400
Received: from smtp.enter.net ([216.193.128.24]:2345 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762140AbYEEVL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:11:58 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: git trees which are not yet in linux-next
Date: Mon, 5 May 2008 17:11:52 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       sfrench@us.ibm.com, swhiteho@redhat.com, stefanr@s5r6.in-berlin.de,
       jeff@garzik.org, ralf@linux-mips.org, drzeus-list@drzeus.cx,
       jack@ucw.cz, cbou@mail.ru, jens.axboe@oracle.com, ericvh@gmail.com,
       wim@iguana.be, chris@zankel.net, nico@cam.org, clameter@sgi.com,
       ezk@cs.sunysb.edu, linux-kernel@vger.kernel.org
References: <20080502151206.b40f77ea.akpm@linux-foundation.org> <20080505113128.d68863a2.akpm@linux-foundation.org> <Pine.LNX.4.64.0805052136530.5570@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0805052136530.5570@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051711.55278.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008 14:41:53 Pekka J Enberg wrote:
> On Mon, 5 May 2008 21:16:12 +0300
>
> "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:
> > > I was looking at preparing a for-next branch for the SLAB tree but I'm
> > > not sure I understand the above. For something like the slab
> > > allocator, you want as much exposure as possible before asking Linus
> > > to pull so I would like to continue to (ab)use -mm for testing as
> > > well. But that doesn't seem to fit the linux-next rules at all...
>
> On Mon, 5 May 2008, Andrew Morton wrote:
> > You have stuff in your tree which isn't intended for 2.6.27??
>
> Heh, no, but I did read somewhere that you're only supposed to put patches
> in 'next' that you consider to be good enough for Linus to pull.
>
> On Mon, 5 May 2008 21:16:12 +0300
>
> "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:
> > > So what to do here? I don't have a problem with maintaining separate
> > > branches for mm and next where the latter is not going to get much
> > > action until very late in the release cycle when I'm preparing for the
> > > next merge window.
>
> On Mon, 5 May 2008, Andrew Morton wrote:
> > I don't mind, really - just do what you think is best for your subsystem
> > and then tell me and Stephen about it.  We'll only notice if you break
> > stuff ;)
> >
> > So I'd suggest that you have a #for-next which contains material for
> > 2.6.26 and 2.6.27 and a #for-mm which contains material for 2.6.28+.
> >
> > Only problem is, I'd need to generate the #for-next -> #for-mm diff, and
> > that particular git operation has been troublesome in the past.
> >
> > otoh, I think that staging for-2.6.26 and for-2.6.27 material in -mm
> > really is reaching far enough into the future, and I'd question the value
> > of staging for-2.6.28+ material as well.  I mean, that's half a year
> > away.
>
> Well, I only really have three kinds of patches: (1) testing, (2)
> for-linus asap (fixes in the middle of a release cycle) and (3) for-linus
> when the merge window opens. Up until now, I've put (1) in for-mm and
> after enough exposure (and no bug reports) they graduate into (2) or (3).
>
> So the problem here is where I put the patches in category (1)? If
> they can go into for-next, then for-mm can disappear. Stephen?
>
> 		Pekka
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

I think (1) would be for-mm, (2) would be pushed to Linus ASAP and (3) would 
be for-next. (unless I've gotten the intent of the various trees mixed up 
somewhere while tracking this discussion)

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
