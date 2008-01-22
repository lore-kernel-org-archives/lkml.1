Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbYAVQ2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbYAVQ2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYAVQ2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:28:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54332 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbYAVQ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:28:01 -0500
Subject: Re: 2.6.24-rc7 to 2.6.24-rc8 possible regression
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Denys Fedoryshchenko <denys@visp.net.lb>, linux-kernel@vger.kernel.org
In-Reply-To: <4796189F.8070506@s5r6.in-berlin.de>
References: <20080121160255.M12670@visp.net.lb>
	 <47952094.9050102@s5r6.in-berlin.de> <20080122110448.M46928@visp.net.lb>
	 <4796189F.8070506@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 17:28:03 +0100
Message-Id: <1201019283.6341.28.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 17:23 +0100, Stefan Richter wrote:
> Denys Fedoryshchenko wrote:
> > No, i am using vanilla kernel. It is one of production machines, and as i 
> > know screen is not using epoll.
> 
> OK, but the trace shows that it is the epoll recursion again.
> 
> > I will try to apply on all my production machines this patch. Sorry if it is 
> > related.
> 
> Well, let's hope that the lockdep annotation or whatever other fix gets
> into mainline sooner than later.  Which reminds me to test my setup
> again which appeared to be able to reproduce the __wake_up recursion on
> my command...

Would be appreciated, I have been waiting on testing feedback because
I'm not fully certain here.

Curious though that this gets reported frequently the last few weeks,
afaics this problem is way old.

