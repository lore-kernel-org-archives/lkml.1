Return-Path: <linux-kernel-owner+w=401wt.eu-S1752399Ab0ABK4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab0ABK4M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 05:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272Ab0ABK4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 05:56:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47670 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0ABK4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 05:56:10 -0500
Date: Sat, 2 Jan 2010 11:55:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org,
       Greg KH <greg@kroah.com>
Subject: Re: tree with htc dream support
Message-ID: <20100102105546.GD9742@elf.ucw.cz>
References: <a55d774e0912271220p1d102b1dr398e0524c9386702@mail.gmail.com>
 <20091227203704.GK11737@elf.ucw.cz>
 <20091227211322.GB29174@elf.ucw.cz>
 <a55d774e0912271646m1b82687cy427083e64e91e323@mail.gmail.com>
 <20091227101824.GB1478@ucw.cz>
 <a55d774e0912281224y7360dfdbu8a251743026bdd28@mail.gmail.com>
 <20091228204848.GB1637@ucw.cz>
 <1262049913.17445.27.camel@desktop>
 <20100101151818.GI3944@atrey.karlin.mff.cuni.cz>
 <1262362128.2159.4.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262362128.2159.4.camel@m0nster>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-01-01 08:08:48, Daniel Walker wrote:
> On Fri, 2010-01-01 at 16:18 +0100, Pavel Machek wrote:
> 
> > > I have it in my tree already .. My tree has some duplication over
> > > staging, for instance the rpc code is mostly in my tree, as is the smd
> > > code.
> > 
> > Do you expect you can just merge those for 2.6.34? That would be
> > great.
> 
> I will try ..

Good.

How can I check out that tree? I tried pulling from
git://codeaurora.org/quic/kernel/dwalker/linux-msm.git , but those
changes do not seem to be there. (I tried default, master and for-next
branches).

> One major thing I will not merge is the qdsp stuff .. So it's
> good that it's in staging.. With that I also wanted to mention that
> there is an alsa driver that (I think) uses the qdsp code.. I was
> thinking that the parts of the qdsp code that the alsa driver uses we
> could pull out and add into the alsa driver. Then clean up the alsa
> driver..

I did not have chance to play with audio, yet. I believe qdsp code
should eventually end up in drivers/mfd (or something like that) --
because it does more than audio, but...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
