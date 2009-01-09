Return-Path: <linux-kernel-owner+w=401wt.eu-S1759024AbZAIWYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbZAIWYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:24:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096AbZAIWXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:23:46 -0500
Received: from solo.fdn.fr ([80.67.169.19]:33746 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758721AbZAIWXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:23:45 -0500
Date: Fri, 9 Jan 2009 23:23:41 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dmitry.torokhov@gmail.com, linux-input@vger.kernel.org
Subject: Re: Re (hello?): [PATCH] Let keyboard notifiers modify key codes
Message-ID: <20090109222341.GI5073@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org
References: <20090107005813.GA4987@const.famille.thibault.fr> <20090109212358.GG5073@const.famille.thibault.fr> <20090109213555.7f9275c9@lxorguk.ukuu.org.uk> <20090109214357.GH5073@const.famille.thibault.fr> <20090109220144.6b99ed72@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090109220144.6b99ed72@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox, le Fri 09 Jan 2009 22:01:44 +0000, a écrit :
> > > Surely that is just a new keymap ?
> > 
> > No. That would mean a lot of keymapSSS. Doing it the keymap way
> 
> Why - its an  algorithmic question about how to edit them - remember you
> can edit keymaps in programs at runtime and live.

Right. I'm still afraid by that: we'd need to know how to remap the
various keycodes (amiga, atari, i386, mc, sun).  And we'd have to
double the number of keymaps being used.  Maybe I should have given an
example: somebody with one hand would rather not have to move it to
type everything.  That means we should setup a key which, while being
pressed, changes the keys under his hand, e.g. for a left-handed,
putting l under the usual s, k under the usual d, j under the usual
f, etc.  Of course we'd need to do that for all the shift/alt etc.
variations too, thus double the number of keymaps, which may not
possible, or else we'd drop some of them, but which ones?

I'm also afraid of how to plug that into distributions.  Console
keyboard setup seemed to me quite heterogeous among distributions
already.  (In case somebody wonders, no, a distribution "for disabled
people" is not a good idea, why should disabled people be left with just
one distribution and not have the choice?)

> > This really is a problem that is orthogonal to keymaps: I'm here talking
> > about _physical_ keys remapping, not remapping what is printed on them
> > (which is done after that).
> 
> Ok so this is analogous to the X key remapping.

Not exactly: it's not 1-1, as examplified above.

Thanks,
Samuel
