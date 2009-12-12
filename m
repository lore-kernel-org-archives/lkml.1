Return-Path: <linux-kernel-owner+w=401wt.eu-S1761680AbZLLKk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680AbZLLKk6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 05:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761535AbZLLKk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 05:40:56 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48136 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761529AbZLLKk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 05:40:56 -0500
Date: Sat, 12 Dec 2009 10:42:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091212104205.6a13b5e5@lxorguk.ukuu.org.uk>
In-Reply-To: <20091212084611.GA28266@elte.hu>
References: <20091211232805.GA10652@kroah.com>
	<20091212084611.GA28266@elte.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009 09:46:11 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Greg KH <gregkh@suse.de> wrote:
> 
> > Here's the big TTY patchset for your .33-git tree.
> 
> FYI, one of the changes in this tree is causing lockups on x86.
> 
> Config attached.
> 
> Possible suspects would one of these:
> 
>  36ba782: tty: split the lock up a bit further
>  5ec93d1: tty: Move the leader test in disassociate
>  38c70b2: tty: Push the bkl down a bit in the hangup code
>  f18f949: tty: Push the lock down further into the ldisc code
>  eeb89d9: tty: push the BKL down into the handlers a bit
> 
> as they deal with locking details and are fresher than two weeks.

Any diagnostics with the lockup or just a system hang ?

You can pop back those five and if the lockup then vanishes those are
ones trying to work on hangup and BKL rather than security fixes so can
just get punted to next release
