Return-Path: <linux-kernel-owner+w=401wt.eu-S934612AbYBVUIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934612AbYBVUIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933090AbYBVUGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:06:09 -0500
Received: from el-out-1112.google.com ([209.85.162.180]:62441 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934199AbYBVUGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:06:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XUoXTOIEZiK5FKL4hFXyK6t4s+KErUGeiEaGTHOyz58gdNursdfhchX3HiI7qJaiweiPOZGLOSvyOnv2IGMttYsq3hQJW1LkMg+Le0etRY9xiakE/ZIjGufDO89zMybpdaDpS3VuP6kLICXXiP+/FRaXZD8IuiHqYrmyjjQ/7Pw=
Message-ID: <f19298770802221206j4d56f002mc4c2036842a18f58@mail.gmail.com>
Date: Fri, 22 Feb 2008 23:06:00 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200802221848.37902.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <200802221513.58608.mb@bu3sch.de>
	 <47BF101F.30301@protei.ru> <200802221848.37902.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[replying from my non-work account]

On Fri, Feb 22, 2008 at 8:48 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Friday 22 February 2008 19:10:39 Alexey Zaytsev wrote:
>  > Sorry, I don't get it. You are going to remove the (somehow)
>  > working driver, while there are known problems with the new
>  > one? Why?
>
>  Because the new driver works, if you just set it up right.
>  Until now every "breakage" was just a usage error.
>
>
>  > And please look at the problem from a user's view point. I'm
>  > happily using the 2.6.23 kernel. The bcm43xx driver is the
>  > only one available. And it works somehow (well, no s2ram).
>
>  b43 supports s2ram and s2disk.
>
>
>  > If this is not a repgession, than I don't know what is.
>  > And if it is a regression, it should be fixed at least in the
>  > 2.6.24.y series, do you agree?
>
>  No. Playing with kconfig SELECT is really _nothing_ for a -stable
>  series. I am _not_ going to be responsible for any
>  breakages. And using SELECT _does_ break things. We had dozens of bugs
>  until all the damn dependencies were right. Even "Obviously Correct (tm)"
>  changes to SELECT _do_ break on weird configurations.
>  See the bcm43xx mail archives for examples.
>

Well, someone obviously played with the SELECTs, and broke the bcm43xx driver.
Now I've got a patch that I believe gets the SELECTs right and fixes
the driver, so
what is wrong?

>  If you need that patch for some reason, please apply it locally.
>  The problem will automatically get fixed when bcm43xx goes away, soon.
>
>
>  > I have provided a patch that I believe is trivial, that I have
>  > tested with all possible config option combinations I thought
>  > were possible, and that fixes the regression. If you have a
>  > reason to believe it is wrong, please say it, I won't be
>  > offended. If there is a problem with the patch, I'll gladly
>  > fix and resend it.
>  >
>  > This Nack leaves me with one option - to switch back to 2.6.23.
>  > Sorry, no testing, probably more bugs not found in 2.6.24. ;(
>
>  It is not my problem, if you refuse to use b43.
>  You also still refuse to tell me details about your card and _what_
>  does not work. I do own lots of different card and they
>  all work fine with b43. There's one exception, the 4311 rev 3 (or something,
>  don't quite remember). But patches are available and will ship in 2.6.25.
>  bcm43xx won't get removed until that shipped.

Yes, it's a 4311 rev 01, but I'm probably was just too lame to upgrade the
firmware or something. :E

I really don't get it, what is going on here? You state that the new b32 driver
has problems on some hardware, where the old bcm43xx driver just works.
And at the same time, you are surprised that I "refuse" to use the b43 driver
and push patches for the bcm43xx driver you broke... Oh, really, why?!
