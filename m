Return-Path: <linux-kernel-owner+w=401wt.eu-S1761906AbXFRArh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761906AbXFRArh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 20:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbXFRAra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 20:47:30 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1491 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbXFRAra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 20:47:30 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 17 Jun 2007 17:47:27 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: And now for something _totally_ different: Linux v2.6.22-rc5
In-Reply-To: <1182127391.26853.207.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0706171746020.5316@alien.or.mcafeemobile.com>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
  <1182064500.2798.6.camel@entropy>  <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com>
  <1182108399.3794.4.camel@entropy>  <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com>
  <1182125303.3794.8.camel@entropy>  <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com>
 <1182127391.26853.207.camel@localhost.localdomain>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Benjamin Herrenschmidt wrote:

> On Sun, 2007-06-17 at 17:20 -0700, Davide Libenzi wrote:
> > > 
> > > I didn't see anything like that in linux.git, missed Ben's patch to
> > the
> > > list, and mixed up your description with the original TIF_SIGPENDING
> > > work.
> > 
> > They will still race on the signal queue though. That is, if you
> > create a 
> > signalfd and three threads are doing a read(2) over it, if a signal
> > is 
> > sent to the thread group (tsk->signal->shared_pending), only one will 
> > fetch the signal. I think that's the correct behaviour anyway.
> > Andrew or Linus, did you get Ben's patch?
> 
> It might have been missed... I can resend later today.

Try to put a "GPLV3" somewhere in the subject. It might have better 
chances to get through Linus radar these days :D



- Davide


