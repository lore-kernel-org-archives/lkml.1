Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbYBXRR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbYBXRR2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 12:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYBXRRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 12:17:19 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:49760 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbYBXRRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 12:17:18 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Sun, 24 Feb 2008 18:16:01 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <47BEAF3B.3080809@protei.ru> <200802241529.50967.mb@bu3sch.de> <f19298770802240839w2c19fd52vb0d170359ba56fc5@mail.gmail.com>
In-Reply-To: <f19298770802240839w2c19fd52vb0d170359ba56fc5@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802241816.01784.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 February 2008, Alexey Zaytsev wrote:
> On Sun, Feb 24, 2008 at 5:29 PM, Michael Buesch <mb@bu3sch.de> wrote:
> > On Saturday 23 February 2008 12:32:50 Alexey Zaytsev wrote:
> >  > The problem is not with enabling both b43 and bcm43xx (will, whis won't work
> >  > anyway, and there is no chance fixing it). The problem is with enabling the
> >  > bcm43xx wifi driver and the b44 Ethernet driver. The ethernet driver then
> >  > wrongly autosolects some config options that prevent the bcm43xx
> >  > driver from loading, so I'm left with either no wifi or no ethenet.
> >
> >  Ok, so I just tested this on a machine and it is _not_ true.
> >  It works just fine to run b44/ssb with bcm43xx in parallel.
> >
> >  Can you please stop fooling me and spreading this FUD?
> >
> 
> The ony way I see this was possible, you manually changed the
> module loading order, so that the b43xx module was loaded prior
> to the ssb and b44 modules. Right?

Right. So "so I'm left with either no wifi or no ethenet" being wrong.

> Looks like this, kind of, ruins my statement that is is impossible to get
> working wifi in 2.6.24. Sorry, it was not intensinal. ;)

Ok, I see.

> But there still are lots of valid combinations where the b43xx driver
> silently won't work. E.g. when either the ssb or the b44 modules are
> loaded prior to it, or when either of them are built statically (building
> the b43xx driver staticaly won't help here). And my patch fixes them.

With your patch you can still artificially create situations that
something doesn't work.
My point being: It works just fine without the patch.
And as I'm not really sure about the implications of the patch, I
won't ack this. But it seems Larry acked it. So that's also fine, if
he takes over responsibility for that change then. So the next
"You broke my kernel!!11" round can go to his mail address and I won't
be bothered by this anymore. ;)
