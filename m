Return-Path: <linux-kernel-owner+w=401wt.eu-S966067AbXDCTVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966067AbXDCTVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbXDCTVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:21:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60446 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbXDCTVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:21:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Date: Tue, 3 Apr 2007 21:25:13 +0200
User-Agent: KMail/1.9.5
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
References: <20070402053457.GA9076@in.ibm.com> <20070403125619.GA32444@in.ibm.com> <20070403141516.GB14900@in.ibm.com>
In-Reply-To: <20070403141516.GB14900@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704032125.14742.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 April 2007 16:15, Gautham R Shenoy wrote:
> On Tue, Apr 03, 2007 at 06:26:19PM +0530, Srivatsa Vaddagiri wrote:
> > 
> > Besides, how problematic is this in practise (that threads sleep for
> > extended durations in TASK_INTERRUPTIBLE state breaking
> > freezer/suspend/hotplug)?
> > 
> > Should we ignore this for the timebeing and take up later as and when
> > users report problems?
> 
> In my case, the problem of freezer failing was due to the vfork freezer race
> in do_fork. The parent task was waiting_for_completion() while the child was
> frozen.
> 
> Rafael has already sent out the fix for that, but for some reason I
> don't see it in the -mm.

Hm, freezer-fix-vfork-problem.patch is in -rc5-mm3.  Is it the patch you're
talking about or is there another one?

Rafael
