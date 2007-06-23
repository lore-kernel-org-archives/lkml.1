Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbXFWAMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbXFWAMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 20:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbXFWAMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 20:12:09 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3829 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbXFWAMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 20:12:08 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 22 Jun 2007 17:12:00 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nicholas Miell <nmiell@comcast.net>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
In-Reply-To: <1182555727.2735.3.camel@entropy>
Message-ID: <Pine.LNX.4.64.0706221710150.3880@alien.or.mcafeemobile.com>
References: <20070620111415.GA91@tv-sign.ru> 
 <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org> 
 <20070621082509.GA88@tv-sign.ru>  <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org>
  <20070621182340.GA92@tv-sign.ru>  <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org>
  <20070621185856.GA153@tv-sign.ru>  <1182468604.24740.22.camel@localhost.localdomain>
  <20070622084034.GA134@tv-sign.ru>  <1182512473.24740.54.camel@localhost.localdomain>
  <20070622160405.GA189@tv-sign.ru>  <1182551618.24740.79.camel@localhost.localdomain>
  <alpine.LFD.0.98.0706221540430.3593@woody.linux-foundation.org> 
 <1182554190.24740.84.camel@localhost.localdomain> 
 <1182554371.24740.87.camel@localhost.localdomain> <1182555727.2735.3.camel@entropy>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Nicholas Miell wrote:

> You could just get rid of the process/sighand/whatever reference
> entirely and just make reads on a signalfd always dequeue signals for
> the current thread.

Duh?! ...


> You'd lose the ability to pass signalfds around to other processes, but
> I'm not convinced that is even useful. (But I'm sure somebody smarter
> than me has a valid use case and would love to share :-)

Wasn't it you that bitched (just a few days ago) because multiple threads 
could not use the same signalfd and they (by your initial thought) had to 
create one per thread?



- Davide


