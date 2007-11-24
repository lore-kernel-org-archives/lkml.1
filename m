Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbXKXUwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbXKXUwo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 15:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbXKXUwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 15:52:36 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:57158 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbXKXUwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 15:52:35 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 24 Nov 2007 12:52:27 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/4] Timerfd v2 - new timerfd API
In-Reply-To: <4747B3F0.2020705@gmail.com>
Message-ID: <Pine.LNX.4.64.0711241250510.10489@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.6855.1195854702.2>
 <4747B3F0.2020705@gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2007, Michael Kerrisk wrote:

> > +asmlinkage long sys_timerfd_create(int clockid, int flags)
> >  {
> > -	int error;
> > +	int error, ufd;
> >  	struct timerfd_ctx *ctx;
> >  	struct file *file;
> >  	struct inode *inode;
> > -	struct itimerspec ktmr;
> > -
> > -	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
> > -		return -EFAULT;
> >  
> >  	if (clockid != CLOCK_MONOTONIC &&
> >  	    clockid != CLOCK_REALTIME)
> >  		return -EINVAL;
> 
> Could I suggest here, the following placeholder addition:
> 
> 	if (flags != 0)
> 		return -EINVAL;

Make sense, will repost.


- Davide


