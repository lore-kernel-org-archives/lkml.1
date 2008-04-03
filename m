Return-Path: <linux-kernel-owner+w=401wt.eu-S1760940AbYDCBvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbYDCBvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 21:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757835AbYDCBuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 21:50:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757623AbYDCBuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 21:50:54 -0400
Date: Wed, 2 Apr 2008 18:50:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, josh@freedesktop.org
Subject: Re: [PATCH 7/7] asm-generic: suppress sparse warning in ioctl.h
In-Reply-To: <20080403013420.GV9785@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.00.0804021848140.14670@woody.linux-foundation.org>
References: <1207182818.5740.26.camel@brick> <alpine.LFD.1.00.0804021752040.14670@woody.linux-foundation.org> <20080403013420.GV9785@ZenIV.linux.org.uk>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Apr 2008, Al Viro wrote:
> 
> Umm...  How far do you want sparse to go?  You _really_ don't want
> bug-for-bug compatibility with gcc - it's far too weird (and that's
> even before going into the effects of optimization flags).

I would suggest just accepting link-time constants in constant 
expressions. But yeah, maybe limit even that just to unevaluated 
subexpressions.

That said, for sparse, the right thing to do would be to use 
__builtin_warning() or something, but gcc doesn't have that kind of thing, 
so..

> BTW, what happened with sparse.git?

Yeah, we do seem to have lost a maintainer.

		Linus
