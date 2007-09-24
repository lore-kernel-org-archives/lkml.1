Return-Path: <linux-kernel-owner+w=401wt.eu-S1758460AbXIXUCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbXIXUCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbXIXUCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:02:16 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:49095 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbXIXUCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:02:15 -0400
Date: Mon, 24 Sep 2007 16:01:27 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Paolo Giarrusso <p.giarrusso@gmail.com>
Cc: user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [uml-devel] [PATCH] UML - Fix irqstack crash
Message-ID: <20070924200127.GB25202@c2.user-mode-linux.org>
References: <20070918233336.GA9746@c2.user-mode-linux.org> <20070918170733.c6399124.akpm@linux-foundation.org> <200709201757.56298.p.giarrusso@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709201757.56298.p.giarrusso@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 05:57:49PM +0200, Paolo Giarrusso wrote:
> Yes, indeed - or sign extension on 64bit machines would set to 1 the whole 
> high-word.
> 
> But using long for that mask makes no difference; either int or long
> long (or  better, either u32 or u64) should be used, given that the
> used signal range  is the same on 32 and 64bit machines, it should
> be u32 for normal signals or u64 if RT-signals are also allowed.

We don't use RT signals for anything, so we could use u32.  I don't
see it making much difference though.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
