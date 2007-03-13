Return-Path: <linux-kernel-owner+w=401wt.eu-S965586AbXCMJSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965586AbXCMJSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965607AbXCMJSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:18:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50817 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965586AbXCMJSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:18:13 -0400
Date: Tue, 13 Mar 2007 09:16:29 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Anton Blanchard <anton@samba.org>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] kthread_should_stop_check_freeze (was: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread)
Message-ID: <20070313091629.GA19684@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Srivatsa Vaddagiri <vatsa@in.ibm.com>,
	Anton Blanchard <anton@samba.org>, Pavel Machek <pavel@ucw.cz>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@osdl.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Aneesh Kumar <aneesh.kumar@gmail.com>,
	Gautham R Shenoy <ego@in.ibm.com>
References: <200702260800.49603.rjw@sisk.pl> <20070312043854.GA4124@linux.vnet.ibm.com> <20070312081459.GI5242@elf.ucw.cz> <200703121219.12072.rjw@sisk.pl> <20070312223906.GA9749@elf.ucw.cz> <20070312224524.GB807@kryten> <20070313031411.GC9881@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313031411.GC9881@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 08:44:11AM +0530, Srivatsa Vaddagiri wrote:
> On Mon, Mar 12, 2007 at 05:45:24PM -0500, Anton Blanchard wrote:
> > Then please document it _clearly_ with the kthread code somewhere. 
> 
> Document as well in the kernel_thread() API, as I notice people still
> use kernel_thread() some places (ex: rtasd.c in powerpc arch)?

They shouldn't use kernel_thread.

