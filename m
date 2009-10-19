Return-Path: <linux-kernel-owner+w=401wt.eu-S932415AbZJSXZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbZJSXZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 19:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932383AbZJSXZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 19:25:43 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36098 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353AbZJSXZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 19:25:43 -0400
Date: Tue, 20 Oct 2009 08:24:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: hw-breakpoints: Actually flush thread breakpoints in flush_thread().
Message-ID: <20091019232431.GB18597@linux-sh.org>
References: <20091005102306.GA7889@linux-sh.org> <20091005104955.GA14852@in.ibm.com> <20091009034003.GA7747@linux-sh.org> <20091017234250.GC10344@nowhere> <20091018062558.GA20535@linux-sh.org> <20091019194842.GD4880@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019194842.GD4880@nowhere>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 09:48:45PM +0200, Frederic Weisbecker wrote:
> On Sun, Oct 18, 2009 at 03:25:58PM +0900, Paul Mundt wrote:
> > Thanks. If you're setting up a tree somewhere can you let me know where
> > it will be hosted? I'm pretty much done with the SH support for the
> > existing topic branch in -tip, but if it's being reworked, then I'd like
> > to get my changes reworked and integrated as soon as possible.
> 
> 
> Oh you have based SH breakpoint support on top of the current breakpoint
> API in -tip?
> 
> Hm, you should have talked to us about that since it's being reworked.
> 
Strange, I thought that's what I was doing ;-)

> I'll probably post soon the rebase on top of perf events. And even if
> it gets merged in -tip, it should still be considered as very unstable.
> 
> May be should you better wait for it to get upstream?
> 
I wanted to get the initial support out of the way early to see if there
was anything in the generic code that needed work, but apart from some
minor stuff it's been kept fairly well isolated. The SH support I have
works fine, but isn't a lot of code, and can trivially be reworked on top
of whatever the new interface looks like. I've left out things like
ptrace and kgdb stub integration precisely because I knew the code was
being reworked.

Given that, I'm not in any particular rush, so whenever the reworked
patches are available, I'll give them a run and rebase accordingly.
