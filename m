Return-Path: <linux-kernel-owner+w=401wt.eu-S932268AbXAaCHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbXAaCHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 21:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbXAaCHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 21:07:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:43301 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268AbXAaCHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 21:07:38 -0500
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <00CAB6CF-640D-4449-9CBA-7E52FE9BEC37@oracle.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	 <Pine.LNX.4.64.0701301345060.3611@woody.linux-foundation.org>
	 <0E1E87C3-954C-4297-9D6C-E98BC79D68C3@oracle.com>
	 <Pine.LNX.4.64.0701301448320.3611@woody.linux-foundation.org>
	 <00CAB6CF-640D-4449-9CBA-7E52FE9BEC37@oracle.com>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 13:07:15 +1100
Message-Id: <1170209235.26655.366.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-30 at 15:45 -0800, Zach Brown wrote:
> > Btw, I noticed that you didn't Cc Ingo. Definitely worth doing. Not  
> > just
> > because he's basically the normal scheduler maintainer, but also  
> > because
> > he's historically been involved in things like the async filename  
> > lookup
> > that the in-kernel web server thing used.
> 
> Yeah, that was dumb.  I had him in the cc: initially, then thought it  
> was too large and lobbed a bunch off.  My mistake.
> 
> Ingo, I'm interested in your reaction to the i386-specific mechanics  
> here (the thread_info copies terrify me) and the general notion of  
> how to tie this cleanly into the scheduler.

Thread info copies aren't such a big deal, we do that for irq stacks
already afaik

Ben.


