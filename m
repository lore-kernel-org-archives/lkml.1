Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYBYKjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYBYKjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 05:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYBYKjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 05:39:04 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:44966 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYBYKjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 05:39:01 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Mon, 25 Feb 2008 11:38:24 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Greg KH" <greg@kroah.com>, "Pekka J Enberg" <penberg@cs.helsinki.fi>,
       "Ingo Molnar" <mingo@elte.hu>, "Alexey Zaytsev" <zaytsev.a@protei.ru>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <47BEAF3B.3080809@protei.ru> <20080225064935.GA20997@kroah.com> <f19298770802250223m29f001f5obb8a5dff48df836a@mail.gmail.com>
In-Reply-To: <f19298770802250223m29f001f5obb8a5dff48df836a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802251138.24930.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2008 11:23:02 Alexey Zaytsev wrote:
> On Mon, Feb 25, 2008 at 9:49 AM, Greg KH <greg@kroah.com> wrote:
> >
> > On Mon, Feb 25, 2008 at 08:16:17AM +0200, Pekka J Enberg wrote:
> >  > Hi Michael,
> >  >
> >  > On Sun, 24 Feb 2008, Michael Buesch wrote:
> >  > > > The ony way I see this was possible, you manually changed the
> >  > > > module loading order, so that the b43xx module was loaded prior
> >  > > > to the ssb and b44 modules. Right?
> >  > >
> >  > > Right. So "so I'm left with either no wifi or no ethenet" being wrong.
> >  >
> >  > Lets make this simple: it used to work before and now it doesn't.
> >  > Therefore it's a regression that must be addressed. Period.
> >
> >  Isn't the resolution Michael is suggesting is, "use the different driver"?
> >
> 
> The b43 driver from 2.6.24 does not work with my hardware. The one from
> 2.6.25 seems to work, but 2.6.25 is far from being ready yet.
> 
> The only way you can get the old driver working in 2.6.24 is to
> compile certain (completely unrelated for an outsider) drivers as
> modules and play with the module loading order. I think this is a
> bug, and it should be fixed in -stable.

It must first go into the 2.6.25 tree and then into -stable.
And the patch must be considered to do The Right Thing (tm).

> And for 2.6.25, I think the patch should also be included, as the
> bcm43xx driver is still there.
> 
> Btw, what are we discussing? The real bcm43xx maintainer
> (Larry Finger) reviewed the patch and agreet it should go
> into 2.6.24-stable and 2.6.25 . Now we only have to wait for
> John Linville and Jeff Garzik to pick it up, right? If someone
> still thinks the patch should not go in, he should at least
> add them to the CC list. ;)

Heh, wait. Larry is neither the bcm43xx maintainer [1], nor does this
code touch bcm43xx code. It does touch ssb and b43 code, which I
am the maintainer of.
Though, as I said, if somebody else is familiar with the code does really
understand the patch and does ACK it (which Larry did), I'm probably
OK with applying it. As long as I'm not bothered with any followup
regressions caused by this. So if the one signing off the patch will
handle all this, I'm fine with it.

[1] bcm43xx is unmaintained. Larry used to be the maintainer until
he dropped it a few months ago.

-- 
Greetings Michael.
