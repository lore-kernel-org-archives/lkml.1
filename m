Return-Path: <linux-kernel-owner+w=401wt.eu-S1761566AbXFTT4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761566AbXFTT4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758408AbXFTT4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:56:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51270 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757033AbXFTT4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:56:45 -0400
Date: Wed, 20 Jun 2007 12:56:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] exclude sync signals from signalfd sets
In-Reply-To: <Pine.LNX.4.64.0706201209570.6029@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.0.98.0706201255530.3593@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706201209570.6029@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jun 2007, Davide Libenzi wrote:
> 
> The following patch excludes synchronous signals from being dequeued
> by a signalfd.

I really prefer the current code. Listign special cases is just ugly. Just 
make it so that thread-local signals stay thread-local, and it's all good.

		Linus
