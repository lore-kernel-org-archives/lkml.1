Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZCBVbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZCBVbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZCBVay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:30:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293AbZCBVax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:30:53 -0500
Date: Mon, 2 Mar 2009 13:29:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: david-b@pacbell.net, tglx@linutronix.de, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
Subject: Re: lockdep and threaded IRQs (was: ...)
Message-Id: <20090302132953.27126b78.akpm@linux-foundation.org>
In-Reply-To: <1236028617.18955.14.camel@twins>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	<200903011454.22280.david-b@pacbell.net>
	<1235999772.5330.368.camel@laptop>
	<200903021304.56881.david-b@pacbell.net>
	<1236028617.18955.14.camel@twins>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Mar 2009 22:16:57 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > > we should simply always disable interrupts for 
> > > interrupt handlers.
> > 
> > That would be why you have refused to fix the bug
> > in lockdep, whereby it forcibly enables that flag?
> > 
> > I've been wondering for some months now why you've
> > left that bug unfixed.
> 
> Because running irq handlers with irqs enabled it plain silly.

Do we get to revert irqstacks?
