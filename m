Return-Path: <linux-kernel-owner+w=401wt.eu-S1759876AbYDCB77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876AbYDCB77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 21:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbYDCB7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 21:59:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54034 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869AbYDCB7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 21:59:49 -0400
Date: Thu, 3 Apr 2008 02:59:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, josh@freedesktop.org
Subject: Re: [PATCH 7/7] asm-generic: suppress sparse warning in ioctl.h
Message-ID: <20080403015946.GX9785@ZenIV.linux.org.uk>
References: <1207182818.5740.26.camel@brick> <alpine.LFD.1.00.0804021752040.14670@woody.linux-foundation.org> <20080403013420.GV9785@ZenIV.linux.org.uk> <alpine.LFD.1.00.0804021848140.14670@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804021848140.14670@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 06:50:20PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 3 Apr 2008, Al Viro wrote:
> > 
> > Umm...  How far do you want sparse to go?  You _really_ don't want
> > bug-for-bug compatibility with gcc - it's far too weird (and that's
> > even before going into the effects of optimization flags).
> 
> I would suggest just accepting link-time constants in constant 
> expressions. But yeah, maybe limit even that just to unevaluated 
> subexpressions.

Um...  But that's _not_ a link-time constant - simply an int variable not
defined in any object file...
 
> That said, for sparse, the right thing to do would be to use 
> __builtin_warning() or something, but gcc doesn't have that kind of thing, 
> so..
> 
> > BTW, what happened with sparse.git?
> 
> Yeah, we do seem to have lost a maintainer.
