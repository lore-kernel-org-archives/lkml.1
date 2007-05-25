Return-Path: <linux-kernel-owner+w=401wt.eu-S1763234AbXEYQdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763234AbXEYQdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXEYQdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:33:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49505 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbXEYQdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:33:11 -0400
Date: Fri, 25 May 2007 18:33:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched_clock(): cleanups, #2
Message-ID: <20070525163309.GB24083@one.firstfloor.org>
References: <20070525094640.GL8094@one.firstfloor.org> <20070525101248.GA7547@elte.hu> <20070525112020.GN8094@one.firstfloor.org> <20070525112600.GA27007@elte.hu> <20070525115004.GA4574@elte.hu> <20070525115544.GP8094@one.firstfloor.org> <20070525120228.GA7186@elte.hu> <20070525121540.GA24083@one.firstfloor.org> <20070525091743.5fb569a8.akpm@linux-foundation.org> <1180110374.31211.42.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180110374.31211.42.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I wonder if this was the source of the lockdep selftest failures, or the
> mystery hang this patch caused (IIRC)..

No, the inbalance was just on the ftp server for an hour or so.
I doubt anybody except Ingo ever saw that code.

I introduced it while changing the callbacks around to make the code
easier to read.

-Andi
