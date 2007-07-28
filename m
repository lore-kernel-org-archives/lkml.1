Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbXG1WXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbXG1WXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 18:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbXG1WWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 18:22:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35643 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756511AbXG1WWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 18:22:54 -0400
Date: Sat, 28 Jul 2007 15:22:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, CK Mailinglist <ck@vds.kolivas.org>
Subject: Re: Linus 2.6.23-rc1
In-Reply-To: <Pine.LNX.4.64.0707282355010.9488@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.0.999.0707281518490.3442@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
  <1185588279.1654.1.camel@localhost>  <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
 <1185615848.13701.16.camel@localhost> <alpine.LFD.0.999.0707281035390.3442@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707282054330.15125@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.999.0707281222410.3442@woody.linux-foundation.org>
 <alpine.LFD.0.999.0707281417201.3442@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707282355010.9488@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jul 2007, Jan Engelhardt wrote:
> 
> I generally run with CONFIG_HZ=100, CONFIG_NO_HZ=n, CONFIG_PREEMPT_NONE.

Ok, that's HZ=100 is likely the worst case, as it effectively multiples 
all the scheduler latencies by 10 (rather than by 4, which is what the 
default 250Hz does).

That said, I think most testing showed that the CFS scheduler tunables 
didn't have a huge amount of impact on how things felt, so that 
factor-of-ten might not even matter that much. The 3D game issues may well 
be totally elsewhere.

But it's certainly worth looking at.

		Linus
