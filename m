Return-Path: <linux-kernel-owner+w=401wt.eu-S1765943AbYESNm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765943AbYESNm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765281AbYESNiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:38:01 -0400
Received: from vena.lwn.net ([206.168.112.25]:51809 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765267AbYESNh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:37:59 -0400
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH, RFC] Char dev BKL pushdown v2 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Sun, 18 May 2008 21:00:45 PDT."
             <adatzgv7xjm.fsf@cisco.com> 
Date: Mon, 19 May 2008 07:37:58 -0600
Message-ID: <12244.1211204278@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote:

> Is the plan that we have a pure "push the BKL down" changeset merged,
> and then I can merge BKL removal patches for these places that never
> needed the BKL?  (I guess I can send you such a patch to base on top of
> your tree for when Linus pulls it?  Is 2.6.27 the plan?)  

If you're sure that this code doesn't need the BKL (and it kind of
looked that way to me), the preferred approach seems to be to put in a
comment to that effect so that it's clear that the code has been looked
at.  So sending me a patch which does this would be great.  Otherwise,
if you're willing to swear on top of a stack of Knuth output that the
BKL is not needed for specific open functions, I can revert my patch
back out and put in the comment - whichever you prefer.

jon
