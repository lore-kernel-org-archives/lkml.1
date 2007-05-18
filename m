Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbXERWBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbXERWBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 18:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbXERWA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 18:00:58 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:35165 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560AbXERWA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 18:00:58 -0400
In-Reply-To: <1179499959.2859.579.camel@shinybook.infradead.org>
References: <20070517143200.GA30850@lst.de> <1179413443.3642.49.camel@sauron> <20070517145653.GA968@lst.de> <1179414590.3642.69.camel@sauron> <20070517102931.6bbbad1a.akpm@linux-foundation.org> <pan.2007.05.17.20.30.30@free.fr> <1179455959.2859.527.camel@shinybook.infradead.org> <alpine.DEB.0.99.0705172254560.27207@sigma.j-a-k-j.com> <1179458274.2859.538.camel@shinybook.infradead.org> <alpine.DEB.0.99.0705180750550.8830@sigma.j-a-k-j.com> <1179499959.2859.579.camel@shinybook.infradead.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <6c8c0e6cd0ac95fd1c7d4e822f1e2029@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Matthieu CASTET <castet.matthieu@free.fr>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Date: Sat, 19 May 2007 00:00:56 +0200
To: David Woodhouse <dwmw2@infradead.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Out of curiosity, why would a compiler ever insert padding in a 
>> structure
>> that has all its elements properly-aligned?
>
> Well, it might decide it would be nicer if some elements were aligned 
> to
> 64 bits. Or to a cache line. Or something. I don't care about _why_ --
> the point is that it's _allowed_ to. Hence the original use of
> __attribute__((packed)).

It's not the compiler who decides -- struct layout is
dictated by the ABI you're compiling for.


Segher

