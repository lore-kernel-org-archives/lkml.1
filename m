Return-Path: <linux-kernel-owner+w=401wt.eu-S1751511AbXCMJvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbXCMJvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbXCMJvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:51:45 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37659 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbXCMJvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:51:44 -0400
Date: Tue, 13 Mar 2007 15:28:08 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Christoph Hellwig <hch@infradead.org>, Anton Blanchard <anton@samba.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] kthread_should_stop_check_freeze (was: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread)
Message-ID: <20070313095808.GA19939@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200702260800.49603.rjw@sisk.pl> <20070312043854.GA4124@linux.vnet.ibm.com> <20070312081459.GI5242@elf.ucw.cz> <200703121219.12072.rjw@sisk.pl> <20070312223906.GA9749@elf.ucw.cz> <20070312224524.GB807@kryten> <20070313031411.GC9881@in.ibm.com> <20070313091629.GA19684@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313091629.GA19684@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 09:16:29AM +0000, Christoph Hellwig wrote:
> > Document as well in the kernel_thread() API, as I notice people still
> > use kernel_thread() some places (ex: rtasd.c in powerpc arch)?
> 
> They shouldn't use kernel_thread.

Hmm ..that needs to be documented as well then! I can easily count more
than dozen places where kernel_thread() is being used.

I agree though that kthread is a much cleaner interface to create/destroy 
threads.

-- 
Regards,
vatsa
