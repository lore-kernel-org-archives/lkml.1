Return-Path: <linux-kernel-owner+w=401wt.eu-S1764150AbXK3AFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764150AbXK3AFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 19:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763601AbXK3AF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 19:05:28 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:50337 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761190AbXK3AF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 19:05:27 -0500
Date: Thu, 29 Nov 2007 19:03:41 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 11/11] x86 ptrace merge removals
Message-ID: <20071130000341.GA11177@c2.user-mode-linux.org>
References: <20071129115711.9FC8526F8E7@magilla.localdomain> <20071129120057.5301426F8E7@magilla.localdomain> <20071129140412.GA5412@c2.user-mode-linux.org> <20071129223803.C69A526F8E7@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129223803.C69A526F8E7@magilla.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 02:38:03PM -0800, Roland McGrath wrote:
> > Can you make sure that UML still runs when you're done with ptrace?
> 
> I'd be glad to, especially if you give me some advice on testing (.config
> for um-i386 and um-x86_64, what do try that constitutes "UML still runs").

Use defconfig and boot it.  If you break ptrace, I think it's
overwhelmingly likely that UML will stop booting.  So if UML boots,
I'd say you're good to go, with one caveat.  That is, UML should
report at boot that PTRACE_SYSEMU works.  I put in a fallback from
PTRACE_SYSEMU to PTRACE_SYSCALL when Fedora broke PTRACE_SYSEMU.

> Right now (before these), UML
> doesn't build for x86_64 or i386 from this tree to begin with.

For current -mm, you'll need
http://marc.info/?l=linux-kernel&m=119635496908681&q=raw to build.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
