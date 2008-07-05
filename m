Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbYGESoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbYGESoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 14:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYGESoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 14:44:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbYGESoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 14:44:14 -0400
Date: Sat, 5 Jul 2008 11:44:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@medozas.de>
cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>, linux-ia64@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: the printk problem
In-Reply-To: <alpine.LNX.1.10.0807052039520.28765@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.1.10.0807051142050.2815@woody.linux-foundation.org>
References: <20080705125230.GA20166@damson.getinternet.no> <alpine.LFD.1.10.0807051045520.2815@woody.linux-foundation.org> <alpine.LNX.1.10.0807052039520.28765@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 Jul 2008, Jan Engelhardt wrote:
> 
> So, and what do you do when you run out of alphanumeric characters?

Did you actually look at my patch?

It's not a single alnum character. It's an arbitrary sequence of alnum 
characters. IOW, my patch allows

	%p6N

or something like that for showing a ipv6 "NIP" format string etc. Or you 
could spell them out even more, although I consider it unlikely that you 
really want to see too many of these, since gcc won't actually be able to 
type-check them (so they will always remain _secondary_ formats).

			Linus
