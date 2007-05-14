Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbXENVwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbXENVwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759057AbXENVwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:52:09 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645AbXENVwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:52:08 -0400
Date: Mon, 14 May 2007 14:51:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
Message-Id: <20070514145158.ca5f6174.akpm@linux-foundation.org>
In-Reply-To: <4648D03F.4090407@goop.org>
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>
	<46489818.4000408@goop.org>
	<20070514125946.0f74221c.akpm@linux-foundation.org>
	<4648C062.5090704@goop.org>
	<20070514133745.5bfc34ac.akpm@linux-foundation.org>
	<1179176058.3703.85.camel@mulgrave.il.steeleye.com>
	<20070514140530.8e0491cf.akpm@linux-foundation.org>
	<4648D03F.4090407@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 14:10:23 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > OK, thanks.  I hereby propose that I send the below
> > (voyager-fix-build-broken-by-shift-to-smp_ops.patch) to Linus later today,
> > provided it passes local testing.
> >
> > All those in favour say aye?
> >   
> 
> OK, but only if you don't want to put "i386: move common parts of smp
> into their own file" in front of it, and remove the duplicated code.  I
> could send you a third copy if you like.

Well, let's get the build fix in place first and then we can feed
the cleanup in later on, in a more leisurely fashion?
