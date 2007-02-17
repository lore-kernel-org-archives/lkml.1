Return-Path: <linux-kernel-owner+w=401wt.eu-S1946340AbXBQC3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946340AbXBQC3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 21:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946350AbXBQC3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 21:29:54 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33604 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946340AbXBQC3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 21:29:53 -0500
Date: Sat, 17 Feb 2007 07:59:40 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 2/4] Revert changes to workqueue.c
Message-ID: <20070217022940.GB25924@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214144305.GB19789@in.ibm.com> <20070214200904.GB301@tv-sign.ru> <20070216052626.GB8373@in.ibm.com> <20070216153321.GB83@tv-sign.ru> <20070216164730.GD21457@in.ibm.com> <20070216235939.GB244@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216235939.GB244@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 02:59:39AM +0300, Oleg Nesterov wrote:
> In that case (all processes are frozen when workqueue_cpu_callback()
> calls cleanup_workqueue_thread()) I agree, it is better to just use
> kthread_stop/kthread_should_stop.

Great, thanks!

> This also means that probably it won't be convenient to do this change
> "by small steps" as I suggested before.

Yeah, thats what I thought. We will try to split it to the extent
possible in the next iteration.

Thanks for your feedback/review!

-- 
Regards,
vatsa
