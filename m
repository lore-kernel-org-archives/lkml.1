Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbXFUXqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbXFUXqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXFUXqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:46:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49558 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbXFUXqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:46:39 -0400
Date: Thu, 21 Jun 2007 16:46:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
In-Reply-To: <1182468604.24740.22.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.98.0706211645170.3593@woody.linux-foundation.org>
References: <20070619091452.GA94@tv-sign.ru>  <1182254988.26853.334.camel@localhost.localdomain>
  <20070619140646.GB27343@tv-sign.ru>  <1182295473.26853.386.camel@localhost.localdomain>
  <20070620111415.GA91@tv-sign.ru>  <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org>
  <20070621082509.GA88@tv-sign.ru>  <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org>
  <20070621182340.GA92@tv-sign.ru>  <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org>
  <20070621185856.GA153@tv-sign.ru>
 <1182468604.24740.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Jun 2007, Benjamin Herrenschmidt wrote:
> 
> Yeah well... I wanted to have the least surprise path... that is,
> without my patch, signalfd will "sometimes" steal the SIGSEGV depending
> on who races to the lock first

Oh, absolutely. I thought we all agreed that Ben's patch was the right 
thing. It's been merged for some time now (even if it hasn't been merged 
for as long as I initially _thought_, since I had forgotten to apply the 
the first time around ;)

So yes, all my emails have been about the _current_ code. 

		Linus
