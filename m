Return-Path: <linux-kernel-owner+w=401wt.eu-S932977AbXGTHfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977AbXGTHfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757965AbXGTHfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:35:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38466 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201AbXGTHfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:35:12 -0400
Date: Fri, 20 Jul 2007 09:35:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Uwe Hermann <uwe@hermann-uwe.de>
Cc: Matt Mackall <mpm@selenic.com>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070720073509.GA19833@one.firstfloor.org>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com> <20070718194137.GG11166@waste.org> <20070718201043.GF3898@one.firstfloor.org> <20070718204102.GM11115@waste.org> <20070720072730.GN3700@greenwood>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720072730.GN3700@greenwood>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Some people are putting Linux kernels in the "BIOS" (i.e. ROM chip) when
> using LinuxBIOS (www.linuxbios.org). It _does_ make a lot of difference
> there how big the kernel is. At the moment you can't do that with
> anything smaller than a 1 MB chip. But if people could use 512 KB chips
> because the kernel is small enough that would sure be a great thing.

I'm sure it would be possibel to save a lot of text size. But I don't
think removing the relatively small CPUID code is the right way.
That is just a big maintenance issue for little gain.

If you're seriously interested you should start measuring and then
attack the real bloat pigs. e.g. a good way is to look for unneeded
inlining.

And also do regression testing, like running bloat-o-meter between
releases and complaining about subsystems which have grown unduly.

-Andi
