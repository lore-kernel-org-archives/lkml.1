Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618Ab0ATVIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0ATVIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 16:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499Ab0ATVIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 16:08:16 -0500
Received: from mail.atheros.com ([12.36.123.2]:33478 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab0ATVIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 16:08:16 -0500
Date: Wed, 20 Jan 2010 13:08:14 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mcgrof@gmail.com" <mcgrof@gmail.com>,
       Vikram Kandukuri <Vikram.Kandukuri@atheros.com>,
       SongXing Xu <SongXing.Xu@atheros.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Bluetooth: Add DFU driver for Atheros Bluetooth
 chipset AR3011
Message-ID: <20100120210813.GF10113@tux>
References: <1264017679-19324-1-git-send-email-lrodriguez@atheros.com>
 <1264019268.5591.223.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1264019268.5591.223.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 12:27:48PM -0800, Marcel Holtmann wrote:
> Hi Luis,
> 
> > Signed-off-by: Vikram Kandukuri <vikram.kandukuri@atheros.com>
> > Signed-off-by: Alicke Xu <sxu@atheros.com>
> > Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> > ---
> >
> > Linus, this was merged into linux-next already. The driver is small enough,
> > it just uploads firmware, I figured it would likely be welcomed into 2.6.33-rc5.
> > The patch is the same as it went into linux-next. The firmware is already
> > merged as part of the linux-firmware git tree.
> 
> what is going on here? Overstepping myself and also Dave for merging a
> new driver at this point of time in the development cycle.

I poked you on January 14 about whether or not we can push ath3k into
the 2.6.33 series since it was merged as part of linux-next [1]. I didn't
get a reply to that so I figured I'd try this instead.

[1] http://article.gmane.org/gmane.linux.bluez.kernel/4202/match=ath3k

> The driver is small and self-contained, I agree on that. But remember
> the reason why it was not part of 2.6.33-rc1. You guys actually screwed
> up the submission. And I didn't get any fixes for 1.5 month.

Yeah that first set of patches sucked ass, even the later ones due to the
space crap, I agree completely, our bluetooth team needed to get familiarzed
with the upstream patch process and requirements.

> Now you are pushing it like this?

Well like I said I poked you about it on January, and got no reply. So yes.
I see no point to penalize users for not merging a driver into the 2.6.33
series if its already in linux-next, its so small, and the point of issue
was the original submission from a team completely new to the process.

So you justify not merging the driver into 2.6.33 because the team submitting
it did a terrible job on their first try submitting upstream?

> Dave, I have no objection to merging this. So if you are happy in taking
> in it this late, I include it in the round of fixes that I am putting
> together.

I'll clarify I am not trying to overstep on anyone, but if I get no replies
I will try to push through alternate routes.

Thanks,

  Luis
