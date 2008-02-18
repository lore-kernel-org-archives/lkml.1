Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbYBRXzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbYBRXzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 18:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYBRXzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 18:55:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44948 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323AbYBRXzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 18:55:09 -0500
Date: Mon, 18 Feb 2008 15:54:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc2
In-Reply-To: <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0802181553180.7833@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 Feb 2008, Torsten Kaiser wrote:
>
> [ 5282.056415] ------------[ cut here ]------------
> [ 5282.059757] kernel BUG at lib/list_debug.c:33!

Is there any chance that you could try to bisect this, if it's repeatable 
enough for you? Even if you can't bisect it *all* the way, it would be 
really good to do a handful of bisection runs which should already 
hopefully narrow it down a bit more.

		Linus
