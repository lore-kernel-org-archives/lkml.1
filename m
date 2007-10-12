Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbXJLPbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbXJLPbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 11:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbXJLPbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 11:31:00 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:5130 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbXJLPa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 11:30:59 -0400
Subject: Re: CPU speed after hibernation
From: Bhasker C V <bhasker@unixindia.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200710121407.13024.rjw@sisk.pl>
References: <1192171267.6631.8.camel@h1.unixindia.com>
	 <200710121407.13024.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 12 Oct 2007 21:00:50 +0530
Message-Id: <1192203050.15112.1.camel@h1.unixindia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

 False alarm. 
 The cpu frequency works. But it takes a long time before it 
 brings down the cpu speed. Initialy (atleast for 3-4 minutes) the 
 CPU is kept at its high speed threshold and later the cpu throttling 
 happens.

On Fri, 2007-10-12 at 14:07 +0200, Rafael J. Wysocki wrote:
> On Friday, 12 October 2007 08:41, Bhasker C V wrote:
> > Hi all,
> > 
> >  I have enable suspend-to-disk on myetch system K 2.6.21.1
> >  I have enabled acpi cpu frequency scaling and using "convservative"
> > governer.
> > 
> >  When I boot the system, the cpu frequency works switches fine based on
> > the requirement. But when i go to hibernation and come back from
> > hibernation, the cpu frequency gets stuck at the maximum. 
> > 
> >  I have already written to debian-users list but did not get any reply
> > (with the same subject line). 
> >  Is this a known issue ?
> >  If i try to remove and re-insert the cpufreq_conservative module, the
> > whole system hangs.
> 
> Please try 2.6.23.  If the problem is still there, please file a bug at
> http://bugzilla.kernel.org, under "Power Management"->Hibernation/Suspend.
> 
> Greetings,
> Rafael
-- 
Bhasker C V
Registered Linux user: #306349 (counter.li.org)
The box said "Requires Windows 95, NT, or better", so I installed Linux.

