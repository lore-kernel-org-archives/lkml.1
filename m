Return-Path: <linux-kernel-owner+w=401wt.eu-S1751747AbXCLWqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbXCLWqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXCLWqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:46:55 -0400
Received: from ozlabs.org ([203.10.76.45]:40638 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbXCLWqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:46:54 -0400
Date: Mon, 12 Mar 2007 17:45:24 -0500
From: Anton Blanchard <anton@samba.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] kthread_should_stop_check_freeze (was: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread)
Message-ID: <20070312224524.GB807@kryten>
References: <200702260800.49603.rjw@sisk.pl> <20070312043854.GA4124@linux.vnet.ibm.com> <20070312081459.GI5242@elf.ucw.cz> <200703121219.12072.rjw@sisk.pl> <20070312223906.GA9749@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312223906.GA9749@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Do not do it, then. Confusion it causes is not worth saving one line
> of code. 
> 
> You do less typing, but the resulting code is _less_ readable, not
> more.

Then please document it _clearly_ with the kthread code somewhere. The
reason I brought this up is I had no idea we had to put the freezer gunk
in all kernel thread loops and Ive been writing kernel threads for years.

Anton
