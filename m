Return-Path: <linux-kernel-owner+w=401wt.eu-S1751417AbXCDEmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbXCDEmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 23:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXCDEmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 23:42:11 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:45918 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbXCDEmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 23:42:09 -0500
Date: Sun, 4 Mar 2007 10:04:31 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Anton Blanchard <anton@samba.org>,
       Andrew Morton <akpm@osdl.org>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread
Message-ID: <20070304043431.GA1939@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200702260800.49603.rjw@sisk.pl> <200703011609.43804.rjw@sisk.pl> <20070301193826.GA14587@kryten> <200703012054.26940.rjw@sisk.pl> <20070302213549.GC2373@linux.vnet.ibm.com> <20070302233337.GA267@tv-sign.ru> <20070303005843.GG2373@linux.vnet.ibm.com> <20070303173240.GA249@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070303173240.GA249@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 08:32:40PM +0300, Oleg Nesterov wrote:
> I personally think we should do the opposite, add kthread_should_stop_check_freeze()
> or something. kthread_should_stop() is like signal_pending(), we can use
> it under spin_lock (and it is probably used this way by some out-of-tree
> driver). The new helper is obviously "might_sleep()".

Yes, I agree. It helps the caller explicitly know that this function
-can- freeze.

-- 
Regards,
vatsa
