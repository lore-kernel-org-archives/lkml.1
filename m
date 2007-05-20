Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbXETL3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbXETL3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbXETL3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:29:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34932 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbXETL3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:29:41 -0400
Subject: Re: [PATCH] ubi: kill homegrown endian macros
From: David Woodhouse <dwmw2@infradead.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Matthieu CASTET <castet.matthieu@free.fr>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <315d22bffba5fe251dbe60e4e0d5ced0@kernel.crashing.org>
References: <20070517143200.GA30850@lst.de>
	 <1179413443.3642.49.camel@sauron> <20070517145653.GA968@lst.de>
	 <1179414590.3642.69.camel@sauron>
	 <20070517102931.6bbbad1a.akpm@linux-foundation.org>
	 <pan.2007.05.17.20.30.30@free.fr>
	 <1179455959.2859.527.camel@shinybook.infradead.org>
	 <alpine.DEB.0.99.0705172254560.27207@sigma.j-a-k-j.com>
	 <1179458274.2859.538.camel@shinybook.infradead.org>
	 <alpine.DEB.0.99.0705180750550.8830@sigma.j-a-k-j.com>
	 <1179499959.2859.579.camel@shinybook.infradead.org>
	 <6c8c0e6cd0ac95fd1c7d4e822f1e2029@kernel.crashing.org>
	 <1179540463.2859.627.camel@shinybook.infradead.org>
	 <315d22bffba5fe251dbe60e4e0d5ced0@kernel.crashing.org>
Content-Type: text/plain
Date: Sun, 20 May 2007 12:29:38 +0100
Message-Id: <1179660579.8438.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-19 at 14:24 +0200, Segher Boessenkool wrote:
> >> It's not the compiler who decides -- struct layout is
> >> dictated by the ABI you're compiling for.
> >
> > This is true in the case of externally-visible stuff. I think the
> > compiler is permitted to violate the ABI for purely unit-internal 
> > things
> > if it makes sense though, isn't it?
> 
> Sure.  It isn't "violating the ABI" in that case though,
> to be perfectly clear.

Of course. It's not conforming to the ABI because there's no need to.

> > The rule stands -- empirical testing of what the compiler will do isn't
> > usually the right answer.
> 
> It is *never* the right answer.  You should always write
> your code so that it will do the right thing no matter
> what the compiler decides to do to it.

Well, there's sometimes some benefit in _also_ checking that the output
of the compiler matches your expectations. :)

-- 
dwmw2

