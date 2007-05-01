Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbXEARS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbXEARS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbXEARS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:18:28 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:45244 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbXEARS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:18:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=n8y3JCetzOsUZ43sow42ySnqp5TP1Q/hLG1dOiRDKiYEMEP7h60oVLgaY150z0tI0Sq0a4YTR8jsCIV5K/Iq3H//mH8SRHlngfq5JsAAWqvR3Cqo+Nr92fja01zU2gdQMQvgjAO+dBlZohspqM5MkV4QQKRFZG49J3LmdbQz9h0=
Date: Tue, 1 May 2007 20:18:21 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <97946200.20070501201821@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
CC: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
       <kernel-discuss@handhelds.org>, <linux-kernel@vger.kernel.org>,
       <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [RFC, PATCH 0/4] SoC base drivers
In-Reply-To: <1178031675.5883.67.camel@localhost.localdomain>
References: <1354376306.20070501080806@gmail.com> <46374645.2030900@gmail.com>  <1068016897.20070501173657@gmail.com> <1178031675.5883.67.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Richard,

Tuesday, May 1, 2007, 6:01:15 PM, you wrote:

> On Tue, 2007-05-01 at 17:36 +0300, Paul Sokolovsky wrote:
>>         Either way, I don't pledge to be a HW designer with
>> contemporary lexicon. The aim was simple - as a single word would be
>> too ambiguous, general, or vice-versa, omitting, then acronym is
>> needed, hopefully existing, and not new, and SoC is the most fitting
>> TLA, IMHO. But I'm open to specific suggestions for improvement. For
>> example, if I was to write a Documentation/ entry for that, I'd mention
>> companion chips, peripheral/integrated controllers, etc. But renaming
>> drivers/soc/ to drivers/companion/ would be more confusing, as the
>> concept described is not tied to companion chips per se (even though
>> many of chips we (handhelds.org) deal with, can be classified as
>> such).

> A while back I proposed drivers/mfd/ (multi function devices) and there
> are a couple of drivers in there in mainline which probably fit your
> description of SoC. The code I had once intended for there is probably
> more ASoC related now...

        Well, while description catches the essence of course, TLA is
far from being perfect: 1) Completely unknown; 2) can be easily
confused with mtd.

        But it's even more funny: there *is* drivers/mfd/ already in
mainline. I'd say that we were blind, but even you say "proposed", not
"exists", nor anybody else brought that to attention. I'm afraid, that
proves point 1 above ;-).

        Well, now that it's there, we have little choice but use it, so
we'll move our stuff there.

        Thanks everyone for hints!

> Richard







-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

