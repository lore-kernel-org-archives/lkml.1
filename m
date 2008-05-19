Return-Path: <linux-kernel-owner+w=401wt.eu-S1763291AbYESNqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763291AbYESNqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbYESNqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:46:39 -0400
Received: from vena.lwn.net ([206.168.112.25]:60390 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841AbYESNqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:46:38 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Char dev BKL pushdown v2 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Mon, 19 May 2008 14:03:01 +1000."
             <20080519140301.ae7d4de6.sfr@canb.auug.org.au> 
Date: Mon, 19 May 2008 07:46:38 -0600
Message-ID: <12693.1211204798@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I haven't been following this too closely, so how much of this stuff has
> been posted/review/tested?

This is the second posting (some of the changesets are new this time
around).  It all builds and runs for me, but a lot of this work affects
some of the oldest, most cobweb-filled code around, and I sure don't
have that hardware.  Some others have looked at, but I'm not sure how
deeply.

The basic concept of this work is straightforward, so I have good reason
to hope I've not done anything really stupid.

jon
