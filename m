Return-Path: <linux-kernel-owner+w=401wt.eu-S1759710AbXENUSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759710AbXENUSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbXENUSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:18:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58237 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbXENUSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:18:43 -0400
Date: Mon, 14 May 2007 21:18:17 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Antonino Ingargiola <tritemio@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
Message-ID: <20070514201817.GC20783@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>, Jean Delvare <khali@linux-fr.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Antonino Ingargiola <tritemio@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070514081022.7fcee97f@hyperion.delvare> <5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com> <20070514141437.631fcfd1@hyperion.delvare> <5486cca80705140628w5ff43ebdqf6a5413203226d5@mail.gmail.com> <20070514172138.1c870793@hyperion.delvare> <alpine.LFD.0.98.0705140914410.6739@woody.linux-foundation.org> <20070514202419.33a90f57@hyperion.delvare> <alpine.LFD.0.98.0705141139560.6739@woody.linux-foundation.org> <20070514212807.246c0281@hyperion.delvare> <4648BE31.3020800@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4648BE31.3020800@garzik.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 03:53:21PM -0400, Jeff Garzik wrote:
> Jean Delvare wrote:
> >On Mon, 14 May 2007 11:43:45 -0700 (PDT), Linus Torvalds wrote:
> >>On Mon, 14 May 2007, Jean Delvare wrote:
> >>>Sure, we don't allow that. Except for xfsprogs in 2.6.1, procps in
> >>>2.6.4, oprofile in 2.6.13 and udev in 2.6.19, of course.
> >>And we really complained about it! The oprofile thing should be fixed, 
> >>btw, and yeah,if udev breaks any more, I'll have to stop taking patches 
> >>from Greg. That thing has been a disaster, and everybody involved should 
> >>be ashamed and now hopefully *very* aware of the fact that we don't break 
> >>user-level interfaces.
> >>
> >>(Right now, I suspect we may have a loop setup regression. Not sure)
> >
> >While I'm all for keeping things relatively stable and not asking the
> >user to constantly upgrade user-space, I believe that we just can't
> >promise to never break user-level interfaces while keeping the
> >development pace we have right now. We can promise to grant people
> >significant delay before we drop compatibility options, but "forever"
> >doesn't scale.
> >
> >If you really want to enforce the "never" rule, be prepared to either
> >see development slow down and finally come to a stop, or see the code
> >become unmaintainable and insecure and nobody is longer willing to work
> >on it.
> 
> Why do you think we -stopped- enforcing such a rule?   :)
> 
> It's been the rule throughout Linux's history.  syscalls from early 
> Linux binaries should still work, for example.

Except for very rare case (modules support comes to mine) syscall
compatiblity works perfectly.  But that's because syscalls are a very
visible ABI and people don't break them by accident.  They also don't
decide they have a cool new scheme all syscalls need to follow now.

Now compare that to sysfs..
