Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbZLRNyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbZLRNyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZLRNyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:54:07 -0500
Received: from mail.gmx.net ([213.165.64.20]:51989 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751633AbZLRNyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:54:06 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/a3FJnAr3aZNFucNPRffu5PNu6GRikeV3Ovy5UA8
	RAwtQpACCLjAGl
Subject: Re: x264 benchmarks BFS vs CFS
From: Mike Galbraith <efault@gmx.de>
To: Jason Garrett-Glaser <darkshikari@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Kasper Sandberg <lkml@metanurb.dk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1261140546.15591.5.camel@marge.simson.net>
References: <1261042383.14314.0.camel@localhost>
	 <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
	 <20091217105316.GB26010@elte.hu> <1261047618.14314.6.camel@localhost>
	 <28f2fcbc0912171718x271520b4k5da3376b5182d88a@mail.gmail.com>
	 <20091218052344.GD417@elte.hu> <1261121405.30469.8.camel@marge.simson.net>
	 <28f2fcbc0912180211we599252v39cb94d113537eb5@mail.gmail.com>
	 <1261140546.15591.5.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 14:53:37 +0100
Message-Id: <1261144417.31693.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 13:49 +0100, Mike Galbraith wrote:

> I'll look for x264 source, and patch/piddle.

encoder/encoder.c: In function ‘x264_slice_write’:
encoder/encoder.c:1813: error: ‘x264_t’ has no member named ‘i_threads’
make: *** [encoder/encoder.o] Error 1

marge:..src/x264 # git remote -v
origin  git://git.videolan.org/x264.git (fetch)
origin  git://git.videolan.org/x264.git (push)


