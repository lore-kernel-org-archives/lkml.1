Return-Path: <linux-kernel-owner+w=401wt.eu-S1761937AbZLKAVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761937AbZLKAVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757420AbZLKAVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:21:22 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:58661 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbZLKAVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:21:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ljLuMHA6cLUQ/cx3YVr1Pb3YspuElk9CE6vpMJSOQVGNqehlYMj4D1UA8bFhPe0swx
         26RXygPYCrKBJyoN7E9YGhZcqwqbuxhTu8GlvsnBN5iNoWsb3+LqY9Zkvf23O0jzavqx
         9G/7ltZYTQcZvulwraY3mvP3wafz8FqIHJo2Y=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0912101601100.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	 <alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
	 <1260459601.18520.26.camel@skunk>
	 <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
	 <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
	 <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
	 <6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com>
	 <alpine.LFD.2.00.0912101531180.3560@localhost.localdomain>
	 <20091210235835.20e2269d@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.0912101601100.3560@localhost.localdomain>
Date: Fri, 11 Dec 2009 10:21:27 +1000
Message-ID: <21d7e9970912101621q7aafbd14g8a34bedb75b6c177@mail.gmail.com>
Subject: Re: [git pull] drm
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Stephane Marchesin <stephane.marchesin@gmail.com>,
       Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I realize that you have some emotional attachments to Red Hat, but ask
> yourself (and answer honestly): what would you think if some random other
> distro was packaging tens of thousands of lines of kernel code and not
> apparently working at trying to get them upstream?

Lots of distros do this all the time, you just don't have any hardware
or care about it.
If you didn't have an nvidia box you wouldn't care about this either.
If I send you
an LIRC remote will you bitch about LIRC not being upstream and
Fedora/Ubuntu/everyone
else shipping it?

>
> Dave claims it's only been going on for a few months, but quite frankly,
> we all know better. The nouveau kernel modules have been shipped for a lot
> longer than just F12.

No I know exactly how long we've had the code in Fedora, it predates both
mine and Ben's employment at Red Hat. But it doesn't change the fact
the code has only in the last 2-3 months gotten to a stage where the core
DRM code was able to support it, mainly due to radeon KMS work being
pushed. Previous nouveau drivers shipped were either UMS with an API
that nobody wanted upstream, or KMS with a reliance on a core DRM feature
that no-one wanted upstream. We've been resolving those issues first,
while hoping the lawyers could deal with ctxprogs, guess we moved faster
than them.

I'm going to see what Ben can do with a firmware loader and the ctxprogs,
we can send a patch that contains all the other bits of the driver, however
since the ctxprogs aren't currently something we can add Signed-off-by to,
someone else will have to endeavour to provide them some other way.

Dave.
