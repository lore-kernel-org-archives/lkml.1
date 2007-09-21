Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbXIUPoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbXIUPoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 11:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759444AbXIUPoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 11:44:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbXIUPoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:44:09 -0400
Message-ID: <46F3E692.7070401@redhat.com>
Date: Fri, 21 Sep 2007 11:43:14 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Matthias Hensler <matthias@wspse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       richard kennedy <richard@rsk.demon.co.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
References: <46B10BB7.60900@redhat.com> <20070803113407.0b04d44e.akpm@linux-foundation.org> <20070804084426.GA20464@kobayashi-maru.wspse.de> <20070809095943.GA7763@kobayashi-maru.wspse.de> <20070809095534.25ae1c42.akpm@linux-foundation.org> <46F2E103.8000907@redhat.com> <20070920142927.d87ab5af.akpm@linux-foundation.org> <20070921093914.GB4750@shadowen.org>
In-Reply-To: <20070921093914.GB4750@shadowen.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2007 05:39 AM, Andy Whitcroft wrote:
> This sounds an awful lot like the same problem I reported with fsck
> hanging.  I believe that Hugh had a candidate patch for that, which was
> related to dirty tracking limits.  It seems that that patch tested, and
> acked by Peter.  All on lkml under:
> 
> 	2.6.23-rc6-mm1 -- mkfs stuck in 'D'
> 

Unfortunately that whole thread is about fixing bugs in an already
much-changed balance_dirty_pages() in -mm.
