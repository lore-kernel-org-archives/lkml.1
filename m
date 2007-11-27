Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbXK0Iyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbXK0Iyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 03:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbXK0Iy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 03:54:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40786 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbXK0Iy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 03:54:28 -0500
Date: Tue, 27 Nov 2007 00:53:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/27] ptrace: arch_has_single_step
Message-Id: <20071127005329.9dfcf473.akpm@linux-foundation.org>
In-Reply-To: <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Nov 2007 13:55:07 -0800 (PST) Roland McGrath <roland@redhat.com> wrote:

> This defines the new macro arch_has_single_step() in linux/ptrace.h, a
> default for when asm/ptrace.h does not define it.  It declares the new
> user_enable_single_step and user_disable_single_step functions.
> This is not used yet, but paves the way to harmonize on this interface
> for the arch-specific calls on all machines.

I think I'll duck this lot for now in view of the (relatively small) amount
of followup.

I did do an experimental will-it-apply and got a tremendous number of
rejects against the x86 git tree, almost all of which went away when `patch
-l' was used.  Seems that someone has gone on a whitespace rampage through
arch/x86/ia32/ptrace32.c and arch/x86/ia32/ptrace64.c.

That's kinda/sorta OK, but `patch -l' is a bit more inclined to misplace
hunks and it's all a bit risky.
