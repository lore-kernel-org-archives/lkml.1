Return-Path: <linux-kernel-owner+w=401wt.eu-S1762831AbXJPMqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762831AbXJPMqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 08:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757638AbXJPMqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 08:46:16 -0400
Received: from mx10.go2.pl ([193.17.41.74]:39892 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755190AbXJPMqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 08:46:16 -0400
Date: Tue, 16 Oct 2007 14:49:16 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: david@lang.hm
Cc: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071016124916.GE1000@ff.dom.local>
References: <20071012082534.GB1962@ff.dom.local> <alpine.LFD.0.999.0710120802160.6887@woody.linux-foundation.org> <20071015074405.GA1875@ff.dom.local> <20071015080924.GA32562@wotan.suse.de> <20071015090959.GB1875@ff.dom.local> <20071016005033.GB5851@wotan.suse.de> <20071016090005.GC1000@ff.dom.local> <Pine.LNX.4.64.0710160205100.1538@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710160205100.1538@asgard.lang.hm>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 02:14:17AM -0700, david@lang.hm wrote:
...
> what you don't realize is that Intel (and AMD) have built their business 
> on makeing sure that their new CPU's run existing software with no 
> modifications, (and almost always faster then the old versions). remember 
> that for most of the world, getting the software modified would mean 
> buying a new version, if the vendor bothered to make a different version 
> for the new chip.

It's a good point to always consider when you analyze how something
new should work if it's used with older programs too. But with newer
things like SMP or multithreading they probably have more choice, and
you can only guess what it's done 'officially'.

> if they required everyone to buy new software to use a new chip it 
> wouldn't work well. In fact Intel tried to do exactly withat with the 
> itanium and it has been a spectacular failure (or t the very least, not a 
> spectacular sucess)

The failure of an architecture doesn't mean all specific new
technologies used in itanium were failure too, so they could be back
when needed (and nothing better in reserve) yet.

...
> in theory they could change anything at any time, in practice if they 
> break old software they won't sell the chips, so the modifications tend to 
> be along the lines of this one, adding detail to the specifications so 
> that programmers can get more performance.

I don't think 'not breaking' is much problem here, rather how to use
all new features (which you seem to ignore a bit) to get maximum of
performance without breaking older things. Or, like current problem:
go rational and remove useless (acording to new specs) things, even
without performance gain, or stay 'safe'?

Jarek P.
