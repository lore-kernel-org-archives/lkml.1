Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbXB1LJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbXB1LJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 06:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbXB1LIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 06:08:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40646 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbXB1LIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 06:08:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: vatsa@in.ibm.com
Subject: Re: Problem with freezable workqueues
Date: Wed, 28 Feb 2007 12:11:03 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
References: <200702272251.28844.rjw@sisk.pl> <20070228030113.GJ29179@in.ibm.com> <20070228035149.GL29179@in.ibm.com>
In-Reply-To: <20070228035149.GL29179@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702281211.04515.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 February 2007 04:51, Srivatsa Vaddagiri wrote:
> On Wed, Feb 28, 2007 at 08:31:13AM +0530, Srivatsa Vaddagiri wrote:
> > This problem (of kthread_stopping a frozen thread) was there when we
> > implemented freezer-based cpu hotplug. We worked around that in the
> > callbacks by thawing the worker thread first before kthread_stopping it,
> > which is working pretty neatly.
> > 
> > Should that fix the issue? 
> 
> In addition to thawing worker thread before kthread_stopping it, there
> are minor changes required in worker threads, to check for
> is_cpu_offline(bind_cpu) when they come out of refrigerator and jump to
> wait_to_die if so (ex: softirq.c).
> 
> I guess you would need these changes before freezer-based hotplug is
> merged, in which case Gautham can send those patches out first.

Yes, please, if that's possible.
