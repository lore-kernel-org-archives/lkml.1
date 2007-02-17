Return-Path: <linux-kernel-owner+w=401wt.eu-S965155AbXBQLUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155AbXBQLUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 06:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965184AbXBQLUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 06:20:52 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:55897 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965155AbXBQLUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 06:20:52 -0500
Date: Sat, 17 Feb 2007 16:49:12 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Message-ID: <20070217111912.GA12507@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214202209.GC301@tv-sign.ru> <20070216071617.GB4527@in.ibm.com> <20070216081209.GB2829@in.ibm.com> <20070217053233.GA22435@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217053233.GA22435@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 11:02:33AM +0530, Gautham R Shenoy wrote:

> This looks ok, but probably we could do it in a better way.
> How about an api to thaw only a specific task something like
> thaw_process(struct task_struct p). 

I see that thaw_process already exists in freezer.h! Awesome!!
So lets make use of it, instead of adding the kthread_should_stop 
change to the refrigerator :)

thanks and regards
gautham.

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
