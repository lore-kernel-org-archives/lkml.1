Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867Ab0ATWxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0ATWxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596Ab0ATWxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:53:24 -0500
Received: from senator.holtmann.net ([87.106.208.187]:52703 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab0ATWxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:53:21 -0500
Subject: Re: [PATCH] Bluetooth: Add DFU driver for Atheros Bluetooth
 chipset AR3011
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mcgrof@gmail.com" <mcgrof@gmail.com>,
       Vikram Kandukuri <Vikram.Kandukuri@atheros.com>,
       SongXing Xu <SongXing.Xu@atheros.com>,
       David Miller <davem@davemloft.net>
In-Reply-To: <20100120210813.GF10113@tux>
References: <1264017679-19324-1-git-send-email-lrodriguez@atheros.com>
	 <1264019268.5591.223.camel@localhost.localdomain>
	 <20100120210813.GF10113@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 14:52:53 -0800
Message-ID: <1264027973.5591.241.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> > > Signed-off-by: Vikram Kandukuri <vikram.kandukuri@atheros.com>
> > > Signed-off-by: Alicke Xu <sxu@atheros.com>
> > > Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > > Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> > > ---
> > >
> > > Linus, this was merged into linux-next already. The driver is small enough,
> > > it just uploads firmware, I figured it would likely be welcomed into 2.6.33-rc5.
> > > The patch is the same as it went into linux-next. The firmware is already
> > > merged as part of the linux-firmware git tree.
> > 
> > what is going on here? Overstepping myself and also Dave for merging a
> > new driver at this point of time in the development cycle.
> 
> I poked you on January 14 about whether or not we can push ath3k into
> the 2.6.33 series since it was merged as part of linux-next [1]. I didn't
> get a reply to that so I figured I'd try this instead.
> 
> [1] http://article.gmane.org/gmane.linux.bluez.kernel/4202/match=ath3k

sorry that I missed that email, I read the subject as FYI if you are
using that driver. Which I actually don't since nobody ever send me
hardware ;)

> > The driver is small and self-contained, I agree on that. But remember
> > the reason why it was not part of 2.6.33-rc1. You guys actually screwed
> > up the submission. And I didn't get any fixes for 1.5 month.
> 
> Yeah that first set of patches sucked ass, even the later ones due to the
> space crap, I agree completely, our bluetooth team needed to get familiarzed
> with the upstream patch process and requirements.
> 
> > Now you are pushing it like this?
> 
> Well like I said I poked you about it on January, and got no reply. So yes.
> I see no point to penalize users for not merging a driver into the 2.6.33
> series if its already in linux-next, its so small, and the point of issue
> was the original submission from a team completely new to the process.
> 
> So you justify not merging the driver into 2.6.33 because the team submitting
> it did a terrible job on their first try submitting upstream?

The patch got merged and is in bluetooth-next-2.6 tree. I normally try
to keep the submission to the changes before the merge window opens. And
then the part that didn't make it at that point will be just scheduled
for the next kernel.

If you guys were ready at least by -rc1, I would have most likely pushed
it to Dave right away, but you weren't. So I just decided that the next
merge window is good enough. Since you guys were not responding timely
to my reviews with an updated patch, I figured it doesn't really matter.
The driver is on its way into Linus' kernel. It will be just 2.6.34 at
this point.

> > Dave, I have no objection to merging this. So if you are happy in taking
> > in it this late, I include it in the round of fixes that I am putting
> > together.
> 
> I'll clarify I am not trying to overstep on anyone, but if I get no replies
> I will try to push through alternate routes.

If you feel strongly that the patch needs to go into the current
development kernel, then please mention it somewhere in its submission
to linux-bluetooth. To be honest, once I have it in bluetooth-next-2.6,
the likelihood that I cherry-pick it for the current development kernel
is not that high.

As I said, if Dave is willing to take it, then I cherry-pick it for you
and include it with my next round of fixes.

Regards

Marcel


