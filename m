Return-Path: <linux-kernel-owner+w=401wt.eu-S1751462AbXA2OM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbXA2OM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 09:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbXA2OM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 09:12:56 -0500
Received: from amsfep17-int.chello.nl ([62.179.120.12]:20096 "EHLO
	amsfep17-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbXA2OMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 09:12:55 -0500
Subject: Re: VM: Fix nasty and subtle race in shared mmap'ed page writeback
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Gelmini <gelma@gelma.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070129140844.GE8271@gelma.net>
References: <459C7B24.8080008@yahoo.com.au>
	 <Pine.LNX.4.64.0701032031400.3661@woody.osdl.org>
	 <20070103214121.997be3e6.akpm@osdl.org> <459C98BF.5080409@yahoo.com.au>
	 <20070104131612.GC28470@gelma.net> <459DE3C6.20302@yahoo.com.au>
	 <20070110135453.GH7947@gelma.net> <1168507298.26496.18.camel@twins>
	 <20070112003955.GH4553@gelma.net> <1169457039.2639.17.camel@taijtu>
	 <20070129140844.GE8271@gelma.net>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 15:11:17 +0100
Message-Id: <1170079877.6189.160.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 15:08 +0100, Andrea Gelmini wrote:
> On Mon, Jan 22, 2007 at 10:10:39AM +0100, Peter Zijlstra wrote:
> > On Fri, 2007-01-12 at 01:39 +0100, Andrea Gelmini wrote:
> > > Hi,
> > > 	I can't do the test 'till next week.
> > > 
> > > Thanks a lot for your time,
> > > Gelma
> > 
> > Have you ever gotten around to testing this?
> 
> well, I spent some time doing more deeply test.
> DB corruption happens anyway, even with the kernel that seems to work
> (I say seems because it needs much more effort to get corruption).
> I'm trying to understand it.
> I will work more over it next week.
> 
> thank a lot for your time,

Sure, no problem.

Just a question to clarify matters, which kernels are you testing?
That is, you say corruption is now harder to trigger, is that with
the .20-rc kernels (or .19.2). Or are we talking about .18 + my patch?



