Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbXENUiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbXENUiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757255AbXENUhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:37:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755887AbXENUhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:37:53 -0400
Date: Mon, 14 May 2007 13:37:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
Message-Id: <20070514133745.5bfc34ac.akpm@linux-foundation.org>
In-Reply-To: <4648C062.5090704@goop.org>
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>
	<46489818.4000408@goop.org>
	<20070514125946.0f74221c.akpm@linux-foundation.org>
	<4648C062.5090704@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 13:02:42 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > Does "that" have name?  I can find no patch in -mm which appears to have
> > anything to do with SMP consolidation, and this patch applies cleanly to
> > the current -mm lineup.
> >   
> Sorry, I thought you'd picked this up:
> 
> 
> Subject: i386: move common parts of smp into their own file
> 
> Several parts of kernel/smp.c and smpboot.c are generally useful for
> other subarchitectures and paravirt_ops implementations, so make them
> available for reuse.

Confused.  This patch conflicts a lot with James's one (which I named
voyager-fix-build-broken-by-shift-to-smp_ops.patch).

If your "i386: move common parts of smp into their own file" also fixes
Voyager and is preferred then cool, but a) the changelog should tell us
that and b) could James please test it?

