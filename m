Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbYGaQRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbYGaQRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYGaQRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:17:41 -0400
Received: from vena.lwn.net ([206.168.112.25]:41294 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbYGaQRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:17:40 -0400
Date: Thu, 31 Jul 2008 10:17:38 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Alex Chiang <achiang@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Amanda McPherson <amanda@amcpherson.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] A development process document
Message-ID: <20080731101738.1bf4281c@bike.lwn.net>
In-Reply-To: <20080731062305.GA18070@ldl.fc.hp.com>
References: <20080729143015.0f79cf37@bike.lwn.net>
	<20080731062305.GA18070@ldl.fc.hp.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 00:23:05 -0600
Alex Chiang <achiang@hp.com> wrote:

> Overall, a great document, as expected from you. I've replied with
> "content" comments below.

I've applied most of them, thanks.
 
> But it occurs to me that sending "style" comments to the editor of
> LWN is something akin to, well, some combination of Prometheus,
> Icarus, ravenous vultures, rabid penguins, and telling Linus that
> his choice of $EDITOR sucks, which is to say, "unwise".

Naw, English always needs debugging too.
 
> You've got url reference for some quotes but not all. Would it be
> possible to track them all down? Sorry for asking for all the extra
> work, but I think the references are useful, especially if the
> motivated reader actually visits said reference and gets all sides of
> the story.

I'll see what I can do.  Some of the older ones are kind of hard to find. 
 
> > +Patches must be prepared against a specific version of the
> > kernel.  As a +general rule, a patch should be based on the current
> > mainline as found in +Linus's git tree.  It may become necessary to
> > make versions against -mm,
>    ^^^^^^^
> Hm, is this the new recommended style? Grammar school taught me that
> it should be "Linus'" but I've noticed a gradually changing but
> inconsistently applied new school style.

I actually researched that a while back.  The rule, as far as I can tell
(and to the extent that English has real rules) is that the trailing "s" is
elided only when making a possessive of a plural noun.  "Linus", being very
much a unique, singular entity, needs to be "Linus's" in the possessive
form.
 
> > +If you have a significant series of patches, it is customary to
> > send an +introductory description as part zero.  In general, the
> > second and
> 
> This directly conflicts with akpm's advice:
> 
> 	http://www.zipworld.com.au/~akpm/linux/patches/stuff/tpp.txt
> 
> Section 6(b).

Interesting; Andrew didn't mention that in his review.  I think the intro
postings can be very useful in understanding a patch series as a whole.
Maybe I'll put in something about how anything which should be in the
changelogs needs to go with the actual patches.

Thanks,

jon
