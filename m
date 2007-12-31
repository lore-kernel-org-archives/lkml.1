Return-Path: <linux-kernel-owner+w=401wt.eu-S1759074AbXLaM1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074AbXLaM1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 07:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759466AbXLaM0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 07:26:49 -0500
Received: from ns2.suse.de ([195.135.220.15]:60922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759389AbXLaM0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 07:26:48 -0500
To: Mike Frysinger <vapier@gentoo.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: asm-x86/msr.h for sanitized headers: clean it or punt it
From: Andi Kleen <andi@firstfloor.org>
References: <200712310045.24069.vapier@gentoo.org>
Date: Mon, 31 Dec 2007 13:26:46 +0100
In-Reply-To: <200712310045.24069.vapier@gentoo.org> (Mike Frysinger's message of "Mon\, 31 Dec 2007 00\:45\:23 -0500")
Message-ID: <p73sl1jyrqx.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> writes:

> The current asm-x86/msr.h does not actually define anything for (!__KERNEL__
> && __i386__).  For x86_64, it fails to build due to u32/u64 types being used.
> Simply not installing the header seems easiest to me.  Otherwise, x86_64 will
> need sanitizing and i386 should have things added back, otherwise it's just a
> pointless empty header.

Please don't -- asm/msr.h is very useful in user space for rdtscll et.al.
I use it all the time in test programs.

-Andi
