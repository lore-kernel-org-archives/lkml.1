Return-Path: <linux-kernel-owner+w=401wt.eu-S965910AbYD1StV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965910AbYD1StV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965529AbYD1Ss6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:48:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964908AbYD1Ss5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:48:57 -0400
Date: Mon, 28 Apr 2008 11:47:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/37] Linux Kernel Markers instrumentation for
 sched-devel.git
Message-Id: <20080428114758.bcc08eef.akpm@linux-foundation.org>
In-Reply-To: <20080428184050.GA23391@infradead.org>
References: <20080424150324.802695381@polymtl.ca>
	<1209238735.6441.4.camel@lappy>
	<20080428113610.b2d1e8e4.akpm@linux-foundation.org>
	<20080428184050.GA23391@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 14:40:51 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Apr 28, 2008 at 11:36:10AM -0700, Andrew Morton wrote:
> > It hides the cosmetically-ugly bits, but not the deeply ugly: each of these
> > trace points is an extension to the kernel->userspace API, with all that
> > this implies.
> 
> Not at all.  It's only accessibe to kernel code, so it per defintion
> can't be a userspace API.

eh?  It adds human-readable printk strings.
