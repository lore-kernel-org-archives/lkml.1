Return-Path: <linux-kernel-owner+w=401wt.eu-S1750712AbXB0EAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750712AbXB0EAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 23:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbXB0EAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 23:00:17 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45351 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbXB0EAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 23:00:16 -0500
Date: Mon, 26 Feb 2007 20:00:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] epoll reduced (to 1) number of passes over the ready
 set ...
In-Reply-To: <Pine.LNX.4.64.0702261819250.4949@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0702261959260.12485@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702261819250.4949@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Feb 2007, Davide Libenzi wrote:
> 
> Epoll is doing multiple passes over the ready set at the moment, because 
> of the constraints over the f_op->poll() call. Looking at the code again, 
> I noticed that we already hold the epoll semaphore in read, and this 
> (together with other locking conditions that hold while doing an 
> epoll_wait()) can lead to a smarter way to "ship" events to userspace (in 
> a single pass).

Ok, this looks fine, but I think it makes more sense with (a) a sign-off 
line and perhaps a slightly expanded explanation, and (b) keeping it in 
-mm until after 2.6.21 is out, and merging it then.

Yes? No? Linus is on some crazy drugs again?

		Linus
