Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbXHUU7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbXHUU7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbXHUU7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:59:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:41937 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbXHUU7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:59:23 -0400
In-Reply-To: <5d6222a80708211341s63f8c1eau922f018e66db49f4@mail.gmail.com>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de> <20070821182505.GA20968@puku.stupidest.org> <5d6222a80708211341s63f8c1eau922f018e66db49f4@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <ea37408ece5ef8d2382ad551f74912eb@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, "Jarek Poplawski" <jarkao2@o2.pl>,
       "Adrian Bunk" <bunk@kernel.org>, "Chris Wedgwood" <cw@f00f.org>,
       linux-arch@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: RFC: drop support for gcc < 4.0
Date: Tue, 21 Aug 2007 22:56:52 +0200
To: "Glauber de Oliveira Costa" <glommer@gmail.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Last time I tried a mips build, it would fail the compile unless I was
> using _exactly_ 3.4.4 (I didn't tried older versions, but did try
> 3.4.6, for ex.).

If 3.4.4 works where 3.4.6 doesn't, you should report this as a
bug; either here, or to the GCC team (but please be aware that the
3.4 series isn't supported anymore), or to whoever built that
compiler for you.

> So I also think the 3.4 series will still have to be
> around for a while.

Huh?  3.4 doesn't work for you, so that's why it should stay
a supported compiler?


Segher

