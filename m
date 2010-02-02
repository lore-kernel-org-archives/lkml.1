Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab0BBQm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 11:42:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab0BBQmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 11:42:53 -0500
Date: Tue, 2 Feb 2010 11:42:26 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [RFC] nmi_watchdog: config option to enable new
 nmi_watchdog
Message-ID: <20100202164226.GD3062@redhat.com>
References: <1264622622-5778-1-git-send-email-dzickus@redhat.com>
 <1264622622-5778-4-git-send-email-dzickus@redhat.com>
 <1264690494.4283.2103.camel@laptop>
 <20100128154448.GV4472@redhat.com>
 <20100129081227.GK14636@elte.hu>
 <20100201185218.GC3062@redhat.com>
 <20100202072902.GA29715@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202072902.GA29715@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 08:29:02AM +0100, Ingo Molnar wrote:
> > 
> > Ok.  I guess I am confused what you are suggesting here, to do as Peter 
> > suggested and run both at the same time?
> 
> I dont think we want to run old and new code at once, the old NMI watchdog 
> code is really a hardcoded minimal PMU driver generating a cycles based NMI 
> tick once per second.

Ok.  Agreed.

> 
> > > What do you think?
> > 
> > I will need to give you an updated patch that properly sets the frequency 
> > of the NMI and I probably should still implement a code path that uses the 
> > software perf counters in the cases where the hardware perf counters are 
> > not available.
> > 
> > It seems like you are ok with my approach.  If that is so, I can test on 
> > more machines to iron out some more bugs.  Or did you want to take my 
> > patches as is and have me throw fixes on top?
> 
> Well, all known bugs/showstoppers should be fixed - but otherwise if you 
> think it works fine we can certainly apply it and then iterate it from that 
> point on to increase coverage and add features.

I have a small cleanup to my second patch that makes it functional.  I'll
run some tests on some more machines and post version two tomorrow.  We
can probably build from there.

Cheers,
Don
