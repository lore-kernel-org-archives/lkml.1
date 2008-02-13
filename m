Return-Path: <linux-kernel-owner+w=401wt.eu-S1765125AbYBMAuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765125AbYBMAuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYBMAt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:49:57 -0500
Received: from 1wt.eu ([62.212.114.60]:1887 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764868AbYBMAt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:49:56 -0500
Date: Wed, 13 Feb 2008 01:49:51 +0100
From: Willy Tarreau <w@1wt.eu>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, wferi@niif.hu
Subject: Re: currently active Linux kernel versions
Message-ID: <20080213004951.GA29524@1wt.eu>
References: <47B21F9A.8040904@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B21F9A.8040904@wpkg.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 11:37:14PM +0100, Tomasz Chmielewski wrote:
> Wagner Ferenc wrote:
> 
> >which are the "currently active Linux kernel versions" at any point in
> >time?  The quote is taken from http://lkml.org/lkml/2008/2/11/29.
> >Or more precisely: which are the "stable" versions I can depend on for
> >a more or less critical server, those that have active security
> >support or receive at least critical bugfixes?  I know about the
> >2.6.2[34].y stable git trees, but I wonder how long will those receive
> >attention (that is, security fixes).  Can I find a written policy
> >somewhere?
> 
> I would say:
> 
> a) the kernel your distro provides,

OK for this one

> b) if you're not using a kernel provided by your distribution, the 
> newest kernel from kernel.org

Hummm... he said "a more or less critical server, those that have active
security support or receive at least critical bugfixes". So he does not
want surprizes :-)

> (there are some older, still maintaned kernels with security fixes, too).

I would suggest stable - N-1 for most usages. 2.6.24.y is open, 2.6.23.y is
supposed to be good. The advantage when you proceed like this is that you
can jump from an older kernel to a more recent one which has already got its
share of fixes and is still maintained for some time.

Generally, I would trust Greg when he drops an old kernel, it means that he's
confident enough in the next one.

Willy

