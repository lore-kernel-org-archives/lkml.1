Return-Path: <linux-kernel-owner+w=401wt.eu-S1751475AbXB0EOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbXB0EOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 23:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXB0EOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 23:14:22 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1483 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbXB0EOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 23:14:21 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 26 Feb 2007 20:14:15 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] epoll reduced (to 1) number of passes over the ready
 set ...
In-Reply-To: <Pine.LNX.4.64.0702261959260.12485@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702262005440.10867@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0702261819250.4949@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0702261959260.12485@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Linus Torvalds wrote:

> On Mon, 26 Feb 2007, Davide Libenzi wrote:
> > 
> > Epoll is doing multiple passes over the ready set at the moment, because 
> > of the constraints over the f_op->poll() call. Looking at the code again, 
> > I noticed that we already hold the epoll semaphore in read, and this 
> > (together with other locking conditions that hold while doing an 
> > epoll_wait()) can lead to a smarter way to "ship" events to userspace (in 
> > a single pass).
> 
> Ok, this looks fine, but I think it makes more sense with (a) a sign-off 
> line and perhaps a slightly expanded explanation, and (b) keeping it in 
> -mm until after 2.6.21 is out, and merging it then.
> 
> Yes? No? Linus is on some crazy drugs again?

Let me do more testing. My post was to have more eyes looking at it. Once 
I feel confident about it, and if no objections come from review, I'll 
sign and repost.



- Davide


