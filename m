Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYFGWQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYFGWQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 18:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYFGWQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 18:16:17 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:41783 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752157AbYFGWQQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 18:16:16 -0400
To: David Miller <davem@davemloft.net>, arjan@linux.intel.com,
       dwmw2@infradead.org
Cc: greg@kroah.com, James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-libre@fsfla.org
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the kernel.
References: <1212077700.26088.83.camel@shinybook.infradead.org>
	<20080529164745.GA21763@kroah.com> <483F1232.4010003@linux.intel.com>
	<20080529.140919.160813310.davem@davemloft.net>
From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Sat, 07 Jun 2008 19:14:33 -0300
Message-ID: <orabhw99km.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 29, 2008, David Woodhouse <dwmw2@infradead.org> wrote:

> it's not just from the fundamentalist camp, [...]

> And it isn't just the nutters.

FTR, I take offense at that!  Olives are *not* nuts!  I'm a different
kind of appetizer :-)


On May 29, 2008, David Miller <davem@davemloft.net> wrote:

> If debian or whoever else have these concernes and want to rip the
> firmware out, it is one hundred percent their problem to patch things
> out of the kernel tree they use.

I saw this and some other claims upthread that appear to indicate that
this patch hit a nerve that triggers the well-known Free Software
Movement rejection reflex, so common in LKML.

Moving non-Free firmware within, or even out of, the Linux tree,
wouldn't advance our mission at all.  It wouldn't even make
maintaining Linux-libre easier.  I'd rather it weren't merged.
http://www.fsfla.org/~lxoliva/fsfla/linux-libre/
http://fsfla.org/mailman/listinfo/linux-libre

This may be hard for some of you to believe.  I have no doubt some
might even think this is some unethical tactics to get the patch in.
It's not.  I'm serious when I say I'd rather it weren't merged.
Please let me explain.  This will take some understanding of what I
care about, and what I'm trying to accomplish in life; and some
tolerance to arguments involving ideology, freedom and ethics, because
these are values that move me.  I don't ask you to agree with or share
these values, but if you want to make sense of the paragraph above,
you'll have to at least try to understand what matters to me.


The tolerance for non-Free Software in Linux's sources (and anywhere
else), be it non-Free firmware blobs, be it drivers developed under
NDA (whose code is obscured and harder or impossible to understand and
adapt to one's needs as a consequence of the NDA), all revolve around
acceptance, endorsement and even promotion of unethical practices that
I don't want to condone or participate in.

Working towards retaining the ability for people to distribute and use
blobs along with Linux, rather than merely removing the blobs like we
do in Linux-libre, amounts to condoning this practice.  It does not
advance our cause.  In fact, as others pointed out, such changes make
it easier for unethical vendors to add even more of their blobs to
Linux (or co-maintained packages), which is actually detrimental to
our cause:

On May 29, 2008, Arjan van de Ven <arjan@linux.intel.com> wrote:

> My aim was more the opposite: be able to get MORE firmware easily
> used/loaded, not less.

On May 29, 2008, David Woodhouse <dwmw2@infradead.org> wrote:

> those same companies _would_ consider putting their firmware into a
> non-GPL'd 'linux-firmware' repository instead.


And then, this very patchset started out of a distribution's demand to
preserve the ability to include the non-Free blobs as a condition to
ship a Free kernel (*).  (No, it wasn't Debian).  Now, why would I
want Free Software activists to use, endorse, promote and recommend
such a distro, or a usable strict subset thereof, if such a distro
will go to such lengths to endorse and distribute non-Free Software,
and to reject even *adding* a Free alternative?  Besides, tending to
that demand would be condoning and working towards a practice that is
fundamentally incompatible with what matters most to the Free Software
movement.  No, thanks.

(*) No, saying Linux is Free Software, or even Open Source, is
misleading at best.  All recent, and many not-so-recent, Linux
"source" tarballs published there contain software that fails both the
Free Software and the Open Source definition.  I guess repeating a lie
a sufficient number of times eventually does make it true.


Besides, unless Linux made a commitment to remove and keep out any
non-Free Software (blobs, NDA-obscured drivers), we'd still have to
keep an eye on Linux sources and check each release for non-Free
Software, and remove any remaining and newly-added such software.

But this is precisely what we do and the reason we do maintain
Linux-libre.  I'd even say that, the more non-Free Software moves
about in the the kernel, the more work this makes for us.  (Removal
also makes for work for us, but it happens only once, and it's worth
it because it makes things strictly better in the end.)

And no, 'rm -rf firmware' is not the answer; we have no reason to
remove the (few) Free firmwares in there and, unless all of the
non-Free Software is removed and remains out, distros that don't
switch to Linux-libre or do something equivalent on their own would
still end up shipping a non-Free, non-Open Source kernel, and most
would be misleading their users about that.  "Freedom² is a Feature",
and "main/l/linux-2.6" (rather than non-free) come to mind.


Now, I have no expectations whatsoever that head Linux developers
would make such a commitment to keep non-Free Software outside the
kernel source tree.  I wouldn't even bother trying.  That's just not
where their heart is.  I can live with that, and, nevertheless, I
thank them for their indirect contributions to the Free Software
movement.

After all, it's their hard work on Linux that makes it possible for us
to derive quite easily a Free Software kernel from it (Linux-libre),
to put that together with the GNU operating system (minus the kernel)
and then have a completely Free operating system.  That was the goal
of the first big undertaking of the Free Software movement, the GNU
Project, and this goal is finally achieved, available for all in
several GNU/Linux-libre distributions.


To sum it up: the patchset makes it easier for more firmware to go in;
it won't solve the problem (and render Linux-libre obsolete) unless a
commitment nobody would hope for; it makes for more work in
Linux-libre; and it might get more people to condone and even
recommend distros that tolerate, condone and distribute non-Free
Software.

I hope this makes it clear why I dislike the patchset, the approach
and the demand that led to it.  I hope you now see that the suspicions
that this would advance the software freedom cause were unfounded.
That's why I won't take part in developing it: in spite of its
technical soundness, it would make even more work for me in both
Linux-libre and Linux upstream, in exchange for at best a no-op as far
as my goals of freedom are concerned.

Having cleared this up, I'll leave the technical, legal and strategic
aspects for you to discuss among yourselves.

Have fun.  And please don't bother disputing the values that led to my
conclusion, they're firmly set and the flame war would probably just
annoy everyone who doesn't enjoy this kind of discussion.  Now, if you
find any flaws in the reasoning that took me from the premises to the
conclusions, I'd be happy to read about them and discuss them.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
FSFLA Board Member       ¡Sé Libre! => http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
