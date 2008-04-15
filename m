Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbYDOSnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbYDOSnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYDOSnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:43:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776AbYDOSnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:43:14 -0400
Date: Tue, 15 Apr 2008 11:42:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc8-mm2: Observed problems: Not a detailed bug report
Message-Id: <20080415114228.d379f996.akpm@linux-foundation.org>
In-Reply-To: <1208278829.7230.14.camel@localhost>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
	<1208278829.7230.14.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 11:00:29 -0600 Zan Lynx <zlynx@acm.org> wrote:

> On Thu, 2008-04-10 at 20:33 -0700, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm2/
> 
> I figured that I would post these without details just so they're out
> there.  I've had trouble getting netconsole to dump anything when I need
> it to.  I've also had trouble convincing myself to spend the off-work
> hours I need to narrow it down.
> 
> The general environment is a AMD64 laptop running 64-bit Gentoo, GCC
> 4.3.
> 
> Problem #1:
> Compiling with the stack protector option crashes right after initramfs
> loads.  I think it might be dying while attempting to mount root.
> Simple work around: Don't compile with stack protector.

Yes, there have been a couple of reports of stack-protector problems.

> Problem #2:
> Resume from STR.  The laptop suspends and goes into suspend state with
> the blinking power indicator.  On resume, it simply boots normally
> instead of resuming.  No idea how to debug this one.

hm.  I figured that if suspend worked on the Vaio, it'll work on
everything ;)

>  Bisect I guess.

If you have the time, please.
