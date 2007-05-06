Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbXEFT47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbXEFT47 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 15:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbXEFT47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 15:56:59 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755135AbXEFT47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 15:56:59 -0400
Date: Sun, 6 May 2007 12:54:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ulrich Drepper" <drepper@gmail.com>
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Davi Arnaut" <davi@haxent.com.br>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
Message-Id: <20070506125451.aac4b68f.akpm@linux-foundation.org>
In-Reply-To: <a36005b50705060050q512462edoe53efbc18f754471@mail.gmail.com>
References: <20070502052235.914764000@haxent.com.br>
	<Pine.LNX.4.64.0705021059430.7176@alien.or.mcafeemobile.com>
	<a36005b50705030646v5b729838pe8dc7b91dc9bee2b@mail.gmail.com>
	<Pine.LNX.4.64.0705031111320.6502@alien.or.mcafeemobile.com>
	<a36005b50705031203w14df6f1fp26e186056b0fdef7@mail.gmail.com>
	<Pine.LNX.4.64.0705031433470.6502@alien.or.mcafeemobile.com>
	<a36005b50705040828l28f1d039oe58224ff18286ecd@mail.gmail.com>
	<Pine.LNX.4.64.0705041201390.6958@alien.or.mcafeemobile.com>
	<a36005b50705041638h37cd0654q442e7d50f1e63040@mail.gmail.com>
	<Pine.LNX.4.64.0705051118030.19104@alien.or.mcafeemobile.com>
	<a36005b50705060050q512462edoe53efbc18f754471@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2007 00:50:47 -0700 "Ulrich Drepper" <drepper@gmail.com> wrote:

> > I really do not understand your point. You're too smart to not appreciate
> > the beauty and the simmetry of objects that responds to a common interface
> > (our files, win32 handles), and that fits our existing kernel infrastructure.
> 
> You're blinded by this symmetry.  Not everything that looks like a
> good fit is a good idea.  This is one case.  Get over it, poll is not
> powerful enough to serve as the unifying event mechanism.

What is your position on the timerfd/signalfd/etc patches?

Seems to me that if we were to have fancy new event-delivery machinery
like kevent then the timerfd/signalfd work is heading in the other
direction and ultimately would prove to have been unneeded?
