Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbXK3AJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbXK3AJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 19:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762939AbXK3AJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 19:09:04 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:50358 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbXK3AJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 19:09:02 -0500
Date: Thu, 29 Nov 2007 19:07:42 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, jan.kratochvil@redhat.com
Subject: Re: [PATCH x86/mm 01/11] x86-32 thread_struct.debugreg
Message-ID: <20071130000742.GB11177@c2.user-mode-linux.org>
References: <20071129115711.9FC8526F8E7@magilla.localdomain> <20071129122324.GA11414@elte.hu> <20071129215055.3A79D26F8E7@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129215055.3A79D26F8E7@magilla.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 01:50:55PM -0800, Roland McGrath wrote:
> UML is also a good test, though I have never been set up to verify
> anything beyond "UML seems to boot far enough to complain I don't
> have a userland filesystem for it".  

BTW, this doesn't exercise ptrace at all.  Interesting ptrace things
only start happening when userspace runs.

Grab an interesting-looking image from http://uml.nagafix.co.uk,
uncompress it, and run
	./linux ubda=the-filesystem-image

				Jeff

-- 
Work email - jdike at linux dot intel dot com
