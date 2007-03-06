Return-Path: <linux-kernel-owner+w=401wt.eu-S965349AbXCFRT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965349AbXCFRT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965346AbXCFRT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:19:59 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48466 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965349AbXCFRT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:19:58 -0500
Date: Tue, 6 Mar 2007 09:19:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2] epoll use a single inode ...
In-Reply-To: <200703061812.28478.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703060917500.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com>
 <45ED08A9.9050501@cosmosbay.com> <45ED96A6.3000704@zytor.com>
 <200703061812.28478.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Mar 2007, Eric Dumazet wrote:
> 
> Something like :
> 
> [PATCH] : Use reciprocal divides in sprintf()

Try this on Core 2, and I suspect that you'll find that the hardware is 
actually *faster* than doing the shift/test, function call and the 
two multiplies.

> Using reciprocal divides permits to change each divide by two multiplies, less 
> expensive on current CPUS.

Are you sure?

		Linus
