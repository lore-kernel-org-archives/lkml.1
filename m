Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbZCCJrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbZCCJrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 04:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZCCJrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 04:47:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56145 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753555AbZCCJrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 04:47:36 -0500
Date: Tue, 3 Mar 2009 09:47:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Brownell <david-b@pacbell.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs (was: ...)
Message-ID: <20090303094743.030b2507@lxorguk.ukuu.org.uk>
In-Reply-To: <1236072446.18955.44.camel@twins>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	<200903021633.08736.david-b@pacbell.net>
	<20090303004427.GA8638@elte.hu>
	<200903021837.08635.david-b@pacbell.net>
	<1236072446.18955.44.camel@twins>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Organization: None.. I'm free I'm free bwhahahahaha!
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Therefore IRQF_DISABLED _will_ be forced on everybody some day soon, and
> I'll provide an IRQF_ENABLED for use by broken hardware only (and make a
> TAINT flag for that too).

I don't think you understand how the kernel project works. If everyone
thinks your change is inappropriate it won't get in. You can talk about
forcing things all you like but "force" used that way generally means "new
maintainer required"
