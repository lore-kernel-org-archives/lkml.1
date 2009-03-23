Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbZCWU26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbZCWU26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZCWU2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:28:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37484 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbZCWU2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:28:49 -0400
Date: Mon, 23 Mar 2009 16:28:31 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] degrade severity of lockdep printk
Message-ID: <20090323202831.GC19208@bombadil.infradead.org>
References: <20090323201628.GB19208@bombadil.infradead.org> <20090323202054.GA6395@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323202054.GA6395@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 09:20:54PM +0100, Ingo Molnar wrote:
> 
> Please report it in that case and get us to increase the limit.
> 

https://bugzilla.redhat.com/show_bug.cgi?id=489563

Although I don't really see how this can be particularly fixed, since
any workload that allocates a struct with a lock, initializes, and then
eventually frees it a whole bunch of times will run out of lock_lists
won't it?

(I still think the text should be changed from BUG though since we're
 not actually calling BUG()...)

regards, Kyle
