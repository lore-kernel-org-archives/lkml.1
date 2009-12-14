Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbZLNQAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbZLNQAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbZLNQAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:00:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:35336 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555AbZLNQAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:00:12 -0500
Date: Mon, 14 Dec 2009 08:02:01 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091214080201.466a8998@infradead.org>
In-Reply-To: <200912141139.48115.oliver@neukum.org>
References: <20091212101032.GB25286@elte.hu>
	<20091213191606.GB7297@nowhere>
	<20091213213015.653307b5@infradead.org>
	<200912141139.48115.oliver@neukum.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 11:39:48 +0100
Oliver Neukum <oliver@neukum.org> wrote:

> Am Montag, 14. Dezember 2009 06:30:15 schrieb Arjan van de Ven:
> > > We have the bkl tracepoints for that, attaching an example below,
> > > blkdev_get/bkldev_put is among the highest consumer for me.
> > 
> > we have a trace, but not a number that anyone can just pull out
> > without having to go through great lengths to set stuff up... (esp
> > to capture a boot)...
> > Adding a counter always to the lock_kernel function should be fine
> > instead...
> 
> But don't we need to know how long it is held? If you just count
> you'll make code that drops it while it can look bad.

I think/hope we're well past that. At this point, just the act of taking
it at all is bad.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
