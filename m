Return-Path: <linux-kernel-owner+w=401wt.eu-S1759769AbZCWUkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759769AbZCWUkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbZCWUkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:40:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38760 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbZCWUkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:40:05 -0400
Date: Mon, 23 Mar 2009 16:39:58 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] degrade severity of lockdep printk
Message-ID: <20090323203958.GD19208@bombadil.infradead.org>
References: <20090323201628.GB19208@bombadil.infradead.org> <20090323202054.GA6395@elte.hu> <20090323202831.GC19208@bombadil.infradead.org> <1237840355.24918.80.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237840355.24918.80.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 09:32:35PM +0100, Peter Zijlstra wrote:
> > Although I don't really see how this can be particularly fixed, since
> > any workload that allocates a struct with a lock, initializes, and then
> > eventually frees it a whole bunch of times will run out of lock_lists
> > won't it?
> 
> Not if the lock init site doesn't change. Modules are the big exception,
> cycling modules will run you out of lockdep space..
> 

Somewhat confused by this... possibly I'm just being thick and missing
some subtlety though, but surely the context is equally important?
I mean, the locks held on entry to, say, a fs_operations struct member
function could be different on every different possible callpath...

regards, Kyle
