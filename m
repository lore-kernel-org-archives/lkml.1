Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbXESCH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbXESCH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 22:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbXESCHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 22:07:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60174 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbXESCHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 22:07:49 -0400
Subject: Re: [PATCH] ubi: kill homegrown endian macros
From: David Woodhouse <dwmw2@infradead.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Matthieu CASTET <castet.matthieu@free.fr>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <6c8c0e6cd0ac95fd1c7d4e822f1e2029@kernel.crashing.org>
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
Content-Type: text/plain
Date: Sat, 19 May 2007 10:07:42 +0800
Message-Id: <1179540463.2859.627.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-19 at 00:00 +0200, Segher Boessenkool wrote:
> It's not the compiler who decides -- struct layout is
> dictated by the ABI you're compiling for.

This is true in the case of externally-visible stuff. I think the
compiler is permitted to violate the ABI for purely unit-internal things
if it makes sense though, isn't it?

Besides, in the case of the Linux kernel the ABI in question could be
one of many. It could even be a new one which was added a couple of
weeks ago, and which I had no _chance_ of considering.

The rule stands -- empirical testing of what the compiler will do isn't
usually the right answer.

-- 
dwmw2

