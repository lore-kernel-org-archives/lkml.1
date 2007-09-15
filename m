Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbXIOSgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbXIOSgb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbXIOSgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:36:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35530 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbXIOSgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:36:24 -0400
Date: Sat, 15 Sep 2007 20:36:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Andi Kleen <ak@suse.de>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
Message-ID: <20070915183623.GB14501@one.firstfloor.org>
References: <20070911201219.GA9674@uranus.ravnborg.org> <200709112138.11247.ak@suse.de> <20070911211422.GU3563@stusta.de> <20070915023258.cb5b8048.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070915023258.cb5b8048.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 02:32:58AM -0700, Andrew Morton wrote:
> On Tue, 11 Sep 2007 23:14:22 +0200 Adrian Bunk <bunk@kernel.org> wrote:
> 
> > People do not expect code under arch/i386/ to be used by code under 
> > arch/x86_64/ and vice versa.
> 
> [OT: it drives me batshit that we ended up including stuff in both directions]

Why? 

Anyways, i wouldn't have a problem with putting the already shared
files into a different directory or move it over to one of the architectures, 
although I must admit I personally wouldn't see a big benefit from it. But if 
it gives people a warm fuzzy feeling I'm all for it.

-Andi
