Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbYE2RiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbYE2RiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbYE2RiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:38:06 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:41173 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752128AbYE2RiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:38:04 -0400
Message-ID: <483EE9F9.7020808@gawab.com>
Date: Thu, 29 May 2008 10:38:01 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080522)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Oops in mac80211 with 2.6.26-rc3 triggered playing a video
References: <483A3F91.6020403@gawab.com>	 <19f34abd0805260049j621c882r970444b65e384355@mail.gmail.com>	 <483AECEF.9030509@gawab.com> <19f34abd0805261052v38345716i3e6837ebe5d4a710@mail.gmail.com>
In-Reply-To: <19f34abd0805261052v38345716i3e6837ebe5d4a710@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been testing .26-rc4 and I haven't had it lock up - yet. It seems 
like rc4 is more stable than rc3. It seems to fix some other problems I 
was having.

Vegard Nossum wrote:
> Btw, I don't really see what access point association has to do with
> playing a movie, so I'm inclined to believe the patch actually won't
> fix your problem. But that's what the oops was. Perhaps you were
> unlucky and hit a combination of two different issues... We'll see.
>   
Yeah, I thought the same thing. Why would a network related oops be 
triggered by video playback. It was probably just a coincidence - 
hitting two bugs at once! And I think the video playback lockup was due 
to something that got fixed in rc4 that Linus mentioned.

Linus Torvalds wrote:
> But most of the changes, as usual, are in drivers, at 60%, with some DRI 
> changes leading the way (fixing a number of other regressions, mainly by 
> reverting the under-cooked vblank update).

Justin Madru



