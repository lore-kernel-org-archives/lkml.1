Return-Path: <linux-kernel-owner+w=401wt.eu-S1765483AbXHVQhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765483AbXHVQhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760431AbXHVQhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:37:47 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:49519 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760356AbXHVQhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:37:47 -0400
Date: Wed, 22 Aug 2007 12:37:29 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: user-mode-linux-devel@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [uml-devel] [PATCH] UML - Add a .note.SuSE section
Message-ID: <20070822163729.GB11022@c2.user-mode-linux.org>
References: <20070816162428.GA8128@c2.user-mode-linux.org> <20070816200455.GA14424@uranus.ravnborg.org> <20070816210508.GA10559@c2.user-mode-linux.org> <200708211905.59128.blaisorblade@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708211905.59128.blaisorblade@yahoo.it>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 07:05:53PM +0200, Blaisorblade wrote:
> It's not the first time we hit effects of such bugs, is it? 

I don't remember seeing this before.

> The .note.ABI-tag fix, time ago, may be about the same problem. 

Are you referring to
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c35e584c087381aaa5f1ed40a28b978535c18fb2;hp=a5bd1786fb30abe663b904f6d79bba413e9ba883?
If so, I never understood that - it just came in saying "this fixes
static building", so I sent it along.  BTW, that commit was singled
out by git-bisect as "causing" this particular problem.

> Can you
> double-check all UML linker scripts for more instances of this bug?

I did, I have a patch, and it's been verified to fix the problem.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
