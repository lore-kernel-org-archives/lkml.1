Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbYENWPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbYENWPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYENWPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:15:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbYENWPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:15:40 -0400
Date: Wed, 14 May 2008 15:14:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree 
In-Reply-To: <7207.1210802867@vena.lwn.net>
Message-ID: <alpine.LFD.1.10.0805141512520.3019@woody.linux-foundation.org>
References: <7207.1210802867@vena.lwn.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 May 2008, Jonathan Corbet wrote:
> 
> This is all certainly doable, but it leaves me with one concern: there
> will be no signal to external module maintainers that the change needs
> to be made.  So, beyond doubt, quite a few of them will just continue to
> be shipped unfixed - and they will still run.  If any of them actually
> *need* the BKL, something awful may happen to somebody someday.

External modules have bugs because interfaces change. Film at 11.

It's true, but it definitely shouldn't keep us from just doing it. 
Especially since well-maintained external modules (ie the authors follow 
big discussions like this) can just take the kernel lock regardless of 
kernel version, since it won't even be broken with old kernels.

Of course, well-maintained kernel modules wouldn't depend on the BKL in 
the first place. Oh, well.

		Linus


