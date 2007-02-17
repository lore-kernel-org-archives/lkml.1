Return-Path: <linux-kernel-owner+w=401wt.eu-S1946349AbXBQCba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946349AbXBQCba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 21:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946350AbXBQCba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 21:31:30 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33936 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946349AbXBQCb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 21:31:29 -0500
Date: Sat, 17 Feb 2007 08:01:25 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Message-ID: <20070217023125.GC25924@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214202209.GC301@tv-sign.ru> <20070216071617.GB4527@in.ibm.com> <20070216081209.GB2829@in.ibm.com> <20070216194605.GB192@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216194605.GB192@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 10:46:05PM +0300, Oleg Nesterov wrote:
> Instead, we can just clear PF_FROZEN before kthread_should_stop().

That should work too. Thanks!

> I don't claim this is better, but this way we don't need to add a
> subtle change to process.c.

-- 
Regards,
vatsa
