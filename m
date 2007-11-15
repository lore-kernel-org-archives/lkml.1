Return-Path: <linux-kernel-owner+w=401wt.eu-S933215AbXKOVAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215AbXKOVAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763757AbXKOVA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:00:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37030 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763585AbXKOVAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:00:25 -0500
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel
	Bugs)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bron Gondwana <brong@fastmail.fm>, Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm
In-Reply-To: <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org>
References: <20071113.043207.44732743.davem@davemloft.net>
	 <20071113110259.44c56d42.akpm@linux-foundation.org>
	 <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de>
	 <20071113130411.26ccae12.akpm@linux-foundation.org>
	 <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de>
	 <20071115040708.GB15302@brong.net>
	 <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>
	 <20071115052538.GA21522@brong.net>
	 <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org>
	 <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
	 <20071115115049.GA8297@brong.net>
	 <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org>
	 <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy>
	 <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 21:59:57 +0100
Message-Id: <1195160397.22457.37.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-15 at 12:56 -0800, Linus Torvalds wrote:
> 
> On Thu, 15 Nov 2007, Peter Zijlstra wrote:
> > 
> > Something like this ought to do I guess. Although my
> > mapping_is_buffercache() is the ugliest thing. I'm sure that can be done
> > better.
> 
> No, this absolutely sucks.

Agreed, I was just about to send out an email saying that..

