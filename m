Return-Path: <linux-kernel-owner+w=401wt.eu-S1751444AbXB0EKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbXB0EKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 23:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXB0EKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 23:10:31 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:44308 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbXB0EKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 23:10:30 -0500
Date: Fri, 23 Feb 2007 08:32:24 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, paulmck@linux.vnet.ibm.com, akpm@osdl.org,
       paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: freezer problems
Message-ID: <20070223030224.GA29052@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <200702220010.54126.rjw@sisk.pl> <20070222104747.GA505@tv-sign.ru> <200702221803.41549.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702221803.41549.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 06:03:37PM +0100, Rafael J. Wysocki wrote:
> 
> Why don't we just drop the warning?  try_to_freeze_tasks() should give us a
> warning if there's anything wrong anyway.

The patches look good. I will add my hotplug changes on the top of
these. 

And yeah, removing the warnings from thaw_processes
sounds like a good thing to me. I was constantly getting warnings like
"Strange, but ksoftirqd/1 was not frozen" when ksoftirqd was created in 
the CPU_UP path from the frozen context! 
I was wondering if freezing the processes created from the
frozen context is a good thing to silence these warnings, but I guess that
would open up some new races.


> 
> Greetings,
> Rafael

regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
