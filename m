Return-Path: <linux-kernel-owner+w=401wt.eu-S1752284AbXCLXnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbXCLXnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbXCLXnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:43:37 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:58521 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbXCLXng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:43:36 -0400
Date: Tue, 13 Mar 2007 00:43:35 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Balbir Singh <balbir@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Emelianov <xemul@sw.ru>,
       Kirill@osdl.org, Linux@osdl.org, containers@lists.osdl.org,
       Paul Menage <menage@google.com>, List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/7] RSS controller core
Message-ID: <20070312234335.GA11578@MAIL.13thfloor.at>
Mail-Followup-To: Balbir Singh <balbir@in.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Emelianov <xemul@sw.ru>, Kirill@osdl.org, Linux@osdl.org,
	containers@lists.osdl.org, Paul Menage <menage@google.com>,
	List <linux-kernel@vger.kernel.org>
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru> <20070306140036.4e85bd2f.akpm@linux-foundation.org> <20070309164855.GB3647@MAIL.13thfloor.at> <661de9470703120255k4c4c1d0fy97a2b7a033c7b5b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <661de9470703120255k4c4c1d0fy97a2b7a033c7b5b1@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 03:25:07PM +0530, Balbir Singh wrote:
> > doesn't look so good for me, mainly becaus of the
> > additional per page data and per page processing
> >
> > on 4GB memory, with 100 guests, 50% shared for each
> > guest, this basically means ~1mio pages, 500k shared
> > and 1500k x sizeof(page_container) entries, which
> > roughly boils down to ~25MB of wasted memory ...
> >
> > increase the amount of shared pages and it starts
> > getting worse, but maybe I'm missing something here
> >
> > > We need to decide whether we want to do per-container memory
> > > limitation via these data structures, or whether we do it via
> > > a physical scan of some software zone, possibly based on Mel's
> > > patches.
> >
> > why not do simple page accounting (as done currently
> > in Linux) and use that for the limits, without
> > keeping the reference from container to page?
> >
> > best,
> > Herbert
> >
> 
> Herbert,
> 
> You lost me in the cc list and I almost missed this part of the
> thread. 

hmm, it is very unlikely that this would happen,
for several reasons ... and indeed, checking the 
thread in my mailbox shows that akpm dropped you ...

--------------------------------------------------------------------
Subject: [RFC][PATCH 2/7] RSS controller core
From: Pavel Emelianov <xemul@sw.ru>
To: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       	Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       	Balbir Singh <balbir@in.ibm.com>
Cc: containers@lists.osdl.org,
       	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 06 Mar 2007 17:55:29 +0300
--------------------------------------------------------------------
Subject: Re: [RFC][PATCH 2/7] RSS controller core
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Kirill@smtp.osdl.org, Linux@smtp.osdl.org, containers@lists.osdl.org,
       	Paul Menage <menage@google.com>,
       	List <linux-kernel@vger.kernel.org>
Date: Tue, 6 Mar 2007 14:00:36 -0800
--------------------------------------------------------------------
that's the one I 'group' replied to ...

> Could you please not modify the "cc" list.

I never modify the cc unless explicitely asked
to do so. I wish others would have it that way
too :)

best,
Herbert

> Thanks,
> Balbir
> _______________________________________________
> Containers mailing list
> Containers@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/containers
