Return-Path: <linux-kernel-owner+w=401wt.eu-S1764843AbYBVRu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764843AbYBVRu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761839AbYBVRtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:49:20 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:43410 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764606AbYBVRtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:49:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Alexey Zaytsev <zaytsev.a@protei.ru>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Fri, 22 Feb 2008 18:48:37 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <47BEAF3B.3080809@protei.ru> <200802221513.58608.mb@bu3sch.de> <47BF101F.30301@protei.ru>
In-Reply-To: <47BF101F.30301@protei.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802221848.37902.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008 19:10:39 Alexey Zaytsev wrote:
> Sorry, I don't get it. You are going to remove the (somehow)
> working driver, while there are known problems with the new
> one? Why?

Because the new driver works, if you just set it up right.
Until now every "breakage" was just a usage error.

> And please look at the problem from a user's view point. I'm
> happily using the 2.6.23 kernel. The bcm43xx driver is the
> only one available. And it works somehow (well, no s2ram).

b43 supports s2ram and s2disk.

> If this is not a repgession, than I don't know what is.
> And if it is a regression, it should be fixed at least in the
> 2.6.24.y series, do you agree?

No. Playing with kconfig SELECT is really _nothing_ for a -stable
series. I am _not_ going to be responsible for any
breakages. And using SELECT _does_ break things. We had dozens of bugs
until all the damn dependencies were right. Even "Obviously Correct (tm)"
changes to SELECT _do_ break on weird configurations.
See the bcm43xx mail archives for examples.

If you need that patch for some reason, please apply it locally.
The problem will automatically get fixed when bcm43xx goes away, soon.

> I have provided a patch that I believe is trivial, that I have
> tested with all possible config option combinations I thought
> were possible, and that fixes the regression. If you have a
> reason to believe it is wrong, please say it, I won't be
> offended. If there is a problem with the patch, I'll gladly
> fix and resend it. 
> 
> This Nack leaves me with one option - to switch back to 2.6.23.
> Sorry, no testing, probably more bugs not found in 2.6.24. ;(

It is not my problem, if you refuse to use b43.
You also still refuse to tell me details about your card and _what_
does not work. I do own lots of different card and they
all work fine with b43. There's one exception, the 4311 rev 3 (or something,
don't quite remember). But patches are available and will ship in 2.6.25.
bcm43xx won't get removed until that shipped.

-- 
Greetings Michael.
