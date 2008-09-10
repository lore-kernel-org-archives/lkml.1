Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbYIJBri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbYIJBri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 21:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYIJBr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 21:47:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbYIJBr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 21:47:27 -0400
Date: Tue, 9 Sep 2008 18:46:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-09-08-18-32 uploaded
Message-Id: <20080909184650.360d31f3.akpm@linux-foundation.org>
In-Reply-To: <20080910100142.e74ff1e5.kamezawa.hiroyu@jp.fujitsu.com>
References: <200809090135.m891ZHiW020337@imap1.linux-foundation.org>
	<20080909192544.8c0763d2.kamezawa.hiroyu@jp.fujitsu.com>
	<20080909103741.6e10ee87.akpm@linux-foundation.org>
	<20080910100142.e74ff1e5.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008 10:01:42 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 9 Sep 2008 10:37:41 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > Following is comparison with a mmtom based on rc4.
> > > ===
> > > [rc4mm1]
> > > Execl Throughput                           3004.4 lps   (29.6 secs, 3 samples)
> > > C Compiler Throughput                      1017.9 lpm   (60.0 secs, 3 samples)
> > > Shell Scripts (1 concurrent)               5726.3 lpm   (60.0 secs, 3 samples)
> > > Shell Scripts (8 concurrent)               1124.3 lpm   (60.0 secs, 3 samples)
> > > Shell Scripts (16 concurrent)               576.0 lpm   (60.0 secs, 3 samples)
> > > Dc: sqrt(2) to 99 decimal places         125446.5 lpm   (30.0 secs, 3 samples)
> > > 
> > > [rc5mm1]
> > > Execl Throughput                           3006.5 lps   (29.8 secs, 3 samples)
> > > C Compiler Throughput                      1006.7 lpm   (60.0 secs, 3 samples)
> > > Shell Scripts (1 concurrent)               4863.7 lpm   (60.0 secs, 3 samples)
> > > Shell Scripts (8 concurrent)                943.7 lpm   (60.0 secs, 3 samples)
> > > Shell Scripts (16 concurrent)               482.7 lpm   (60.0 secs, 3 samples)
> > > Dc: sqrt(2) to 99 decimal places         124804.9 lpm   (30.0 secs, 3 samples)
> > > ==
> > > 15% down in shell script test. Any idea ? (scheduler ?)
> > 
> > Dunno.  There is a largel number of debugging patches at the tail of
> > the series so they should be the first thing to eliminate.
> > 
> But I compare mmtom and mmtom, both includes debug series at the tail of series.

oh, sorry, I didn't read closely enough.

Yes, someone broke something.

> I'll revisit this later.

I'd suggest testing linux-next as a first step.

