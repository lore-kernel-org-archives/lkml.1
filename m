Return-Path: <linux-kernel-owner+w=401wt.eu-S967955AbXEHFYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967955AbXEHFYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967950AbXEHFY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:24:28 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967889AbXEHFY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:24:27 -0400
Date: Mon, 7 May 2007 22:24:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org
Subject: Re: sleeping function called from invalid context at
 block/cfq-iosched.c (Was: Re: 2.6.21-mm1)
Message-Id: <20070507222409.2d597a86.akpm@linux-foundation.org>
In-Reply-To: <463FFD0A.2050708@goop.org>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
	<463E3C50.9080207@simon.arlott.org.uk>
	<20070506135403.a6785f7d.akpm@linux-foundation.org>
	<463FAF1C.8060500@simon.arlott.org.uk>
	<20070507162349.0790706f.akpm@linux-foundation.org>
	<463FB697.6060902@simon.arlott.org.uk>
	<20070507163335.f5f5ea6e.akpm@linux-foundation.org>
	<463FFD0A.2050708@goop.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 May 2007 21:31:06 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > Please enable 8k stacks before doing any other debugging things, see if
> > that fixes it.
> 
> I've found that XFS+lvm+4k stacks is completely unusable with current
> kernels.  I get hangs/oopes after ~10mins of work.

Sounds like this is new behaviour?

I wonder why.  Same compiler version?

>  I'm using wli's 8k
> stack + irq stack patches with good success though.
> 

wlis are handy.
