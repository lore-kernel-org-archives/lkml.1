Return-Path: <linux-kernel-owner+w=401wt.eu-S1761757AbYEESp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761757AbYEESp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762304AbYEESdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:33:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762300AbYEESdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:33:31 -0400
Date: Mon, 5 May 2008 11:31:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: linux-next@vger.kernel.org, sfrench@us.ibm.com, swhiteho@redhat.com,
       stefanr@s5r6.in-berlin.de, jeff@garzik.org, ralf@linux-mips.org,
       drzeus-list@drzeus.cx, jack@ucw.cz, cbou@mail.ru, jens.axboe@oracle.com,
       ericvh@gmail.com, wim@iguana.be, chris@zankel.net, nico@cam.org,
       clameter@sgi.com, ezk@cs.sunysb.edu, linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
Message-Id: <20080505113128.d68863a2.akpm@linux-foundation.org>
In-Reply-To: <84144f020805051116mdbbea01q39f17bce95c95dbb@mail.gmail.com>
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>
	<84144f020805051116mdbbea01q39f17bce95c95dbb@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 21:16:12 +0300
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> Hi Andrew,
> 
> On Sat, May 3, 2008 at 1:12 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >  Guys, could you please prepare a tree for Stephen and send the details
> >  over to him?  Please Cc me also.
> >
> >  Once this has happened, there should be no need to run a separate for-mm
> >  branch.  I'll just switch over to using whatever branch linux-next is
> >  using.
> 
> I was looking at preparing a for-next branch for the SLAB tree but I'm
> not sure I understand the above. For something like the slab
> allocator, you want as much exposure as possible before asking Linus
> to pull so I would like to continue to (ab)use -mm for testing as
> well. But that doesn't seem to fit the linux-next rules at all...

You have stuff in your tree which isn't intended for 2.6.27??

> So what to do here? I don't have a problem with maintaining separate
> branches for mm and next where the latter is not going to get much
> action until very late in the release cycle when I'm preparing for the
> next merge window.

I don't mind, really - just do what you think is best for your subsystem
and then tell me and Stephen about it.  We'll only notice if you break
stuff ;)

So I'd suggest that you have a #for-next which contains material for 2.6.26
and 2.6.27 and a #for-mm which contains material for 2.6.28+.

Only problem is, I'd need to generate the #for-next -> #for-mm diff, and
that particular git operation has been troublesome in the past.

otoh, I think that staging for-2.6.26 and for-2.6.27 material in -mm really
is reaching far enough into the future, and I'd question the value of
staging for-2.6.28+ material as well.  I mean, that's half a year away.
