Return-Path: <linux-kernel-owner+w=401wt.eu-S1752320AbXIPHm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbXIPHm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 03:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbXIPHms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 03:42:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46299 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbXIPHmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 03:42:47 -0400
Date: Sun, 16 Sep 2007 00:42:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: vonbrand@inf.utfsm.cl, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: SPARC{,64}: kernel_termios_to_user_termios_1 missing
Message-Id: <20070916004231.cf2df744.akpm@linux-foundation.org>
In-Reply-To: <20070915.153602.74747413.davem@davemloft.net>
References: <200709152137.l8FLbtXP001446@laptop13.inf.utfsm.cl>
	<20070915.153602.74747413.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Sep 2007 15:36:02 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: "Horst H. von Brand" <vonbrand@inf.utfsm.cl>
> Date: Sat, 15 Sep 2007 17:37:55 -0400
> 
> > git-describe says this is v2.6.23-rc6-168-g53a3f30
> > I'm getting:
> > 
> >   drivers/char/tty_ioctl.c: In function 'n_tty_ioctl':
> >   drivers/char/tty_ioctl.c:799: error: implicit declaration of function 'kernel_termios_to_user_termios_1'
> > 
> > This is a macro at the very end of include/asm-<foo>/termios.h for i686, on
> > SPARC and SPARC64 it is missing. Sorry, I've got no clue on how to define
> > this correctly here.
> > 
> > It is also missing on alpha, blackfin, parisc, sh64, sh, xtensa
> 
> This has been reported and discussed extensively on the lists
> over the past 4 or 5 days.

Hopefully bb8bd3a52a5dbca8bea31bfc72dacfb384170e69 (merged six hours ago)
will have fixed this.  It Works For Me.
