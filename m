Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbXESMYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbXESMYr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 08:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbXESMYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 08:24:41 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:44554 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754136AbXESMYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 08:24:40 -0400
In-Reply-To: <1179540463.2859.627.camel@shinybook.infradead.org>
References: <20070517143200.GA30850@lst.de> <1179413443.3642.49.camel@sauron> <20070517145653.GA968@lst.de> <1179414590.3642.69.camel@sauron> <20070517102931.6bbbad1a.akpm@linux-foundation.org> <pan.2007.05.17.20.30.30@free.fr> <1179455959.2859.527.camel@shinybook.infradead.org> <alpine.DEB.0.99.0705172254560.27207@sigma.j-a-k-j.com> <1179458274.2859.538.camel@shinybook.infradead.org> <alpine.DEB.0.99.0705180750550.8830@sigma.j-a-k-j.com> <1179499959.2859.579.camel@shinybook.infradead.org> <6c8c0e6cd0ac95fd1c7d4e822f1e2029@kernel.crashing.org> <1179540463.2859.627.camel@shinybook.infradead.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <315d22bffba5fe251dbe60e4e0d5ced0@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Matthieu CASTET <castet.matthieu@free.fr>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Date: Sat, 19 May 2007 14:24:36 +0200
To: David Woodhouse <dwmw2@infradead.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> It's not the compiler who decides -- struct layout is
>> dictated by the ABI you're compiling for.
>
> This is true in the case of externally-visible stuff. I think the
> compiler is permitted to violate the ABI for purely unit-internal 
> things
> if it makes sense though, isn't it?

Sure.  It isn't "violating the ABI" in that case though,
to be perfectly clear.

> Besides, in the case of the Linux kernel the ABI in question could be
> one of many. It could even be a new one which was added a couple of
> weeks ago, and which I had no _chance_ of considering.

Of course.

> The rule stands -- empirical testing of what the compiler will do isn't
> usually the right answer.

It is *never* the right answer.  You should always write
your code so that it will do the right thing no matter
what the compiler decides to do to it.


Segher

