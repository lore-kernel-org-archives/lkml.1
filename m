Return-Path: <linux-kernel-owner+w=401wt.eu-S933410AbXDFXpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbXDFXpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933416AbXDFXpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:45:42 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39054 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933410AbXDFXpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 19:45:42 -0400
Date: Fri, 6 Apr 2007 16:45:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 18/20] clean up tsc-based sched_clock
Message-Id: <20070406164536.9d747160.akpm@linux-foundation.org>
In-Reply-To: <4616D758.6020300@goop.org>
References: <20070404191151.009821039@goop.org>
	<20070404191206.476822257@goop.org>
	<20070406162233.b835bd4c.akpm@linux-foundation.org>
	<4616D758.6020300@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Apr 2007 16:27:20 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > I still need to work out why that hang is happening - it is very
> > mysterious.  I got as far as working out that it was hanging on
> > write_seqlock_irqsave(xtime_lock), then remembered that it's with
> > CONFIG_SMP=n so I stomped off to bed in disgust.  Later.
> >   
> 
> Hangs always, or just sometimes?  I haven't seen any problems with it.

100%.  On the Vaio, of course.  The kernel's canary.
