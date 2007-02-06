Return-Path: <linux-kernel-owner+w=401wt.eu-S1030221AbXBFWwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030221AbXBFWwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030228AbXBFWwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:52:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54248 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030221AbXBFWwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:52:24 -0500
Date: Tue, 6 Feb 2007 14:51:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>
cc: Matt Mackall <mpm@selenic.com>, David Woodhouse <dwmw2@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <1defaf580702061439w5eca87e6s8d152fdec5f8c627@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702061447390.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> 
 <20070205084523.GA21858@elte.hu>  <1170682488.29759.795.camel@pmac.infradead.org>
  <20070205155627.GA8354@elte.hu>  <1170692539.29759.856.camel@pmac.infradead.org>
  <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu> 
 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org> 
 <1170710272.29759.894.camel@pmac.infradead.org>  <20070206054612.GL16722@waste.org>
 <1defaf580702061439w5eca87e6s8d152fdec5f8c627@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Feb 2007, Haavard Skinnemoen wrote:
> 
> I disagree. I did the exact same thing on AVR32 because !EMBEDDED
> forces on tons of crap that just isn't useful on many embedded
> platforms.

I do agree. EMBEDDED largely means "non-generic/non-standard" these days. 
It's also true that EMBEDDED does *not* necessarily mean "small", since 
some of the choices that it disables can often be choices that you want on 
*big* machines.

For example, the whole thing where VGA and keyboard/mouse support default 
to on when EMBEDDED isn't selected is quite possibly a good reason to 
enable EMBEDDED on big servers that aren't even meant to be general- 
purpose, but simply optimized for a particular environment.

That is, technically, what "embedded" really means. A lot of the time 
people talk about it as if it was always "small", but it can be a big 
computer that is just used in a very specific turn-key environment where 
some of the default kernel choices may not be sensible.

			Linus
