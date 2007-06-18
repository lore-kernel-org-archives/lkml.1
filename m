Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbXFRAnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbXFRAnj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 20:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXFRAna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 20:43:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:44725 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbXFRAna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 20:43:30 -0400
Subject: Re: And now for something _totally_ different: Linux v2.6.22-rc5
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
	 <1182064500.2798.6.camel@entropy>
	 <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com>
	 <1182108399.3794.4.camel@entropy>
	 <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com>
	 <1182125303.3794.8.camel@entropy>
	 <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Mon, 18 Jun 2007 10:43:11 +1000
Message-Id: <1182127391.26853.207.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-17 at 17:20 -0700, Davide Libenzi wrote:
> > 
> > I didn't see anything like that in linux.git, missed Ben's patch to
> the
> > list, and mixed up your description with the original TIF_SIGPENDING
> > work.
> 
> They will still race on the signal queue though. That is, if you
> create a 
> signalfd and three threads are doing a read(2) over it, if a signal
> is 
> sent to the thread group (tsk->signal->shared_pending), only one will 
> fetch the signal. I think that's the correct behaviour anyway.
> Andrew or Linus, did you get Ben's patch?

It might have been missed... I can resend later today.

Ben.


