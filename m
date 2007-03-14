Return-Path: <linux-kernel-owner+w=401wt.eu-S932207AbXCNQLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbXCNQLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 12:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932230AbXCNQLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 12:11:20 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:14178 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbXCNQLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 12:11:19 -0400
Subject: Re: Stolen and degraded time and schedulers
From: Daniel Walker <dwalker@mvista.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk,
       Virtualization Mailing List <virtualization@lists.osdl.org>
In-Reply-To: <45F79B9C.20609@goop.org>
References: <45F6D1D0.6080905@goop.org>
	 <1173816769.22180.14.camel@localhost>  <45F70A71.9090205@goop.org>
	 <1173821224.1416.24.camel@dwalker1>  <45F71EA5.2090203@goop.org>
	 <1173837606.23595.32.camel@imap.mvista.com>  <45F79B9C.20609@goop.org>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 09:11:13 -0700
Message-Id: <1173888673.3101.12.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 23:52 -0700, Jeremy Fitzhardinge wrote:

> >
> > That's true, but given a constant clock (like what sched_clock should
> > have) then the accounting is similarly inaccurate. Any connection
> > between the scheduler and the TSC frequency changes aren't part of the
> > design AFAIK ..
> >   
> 
> Well, my whole argument is that sched_clock /should not/ be a constant
> clock.  And I'm not quite sure why you keep bringing up the tsc, because
> it has no relevance.

Then your direction is wrong, sched_clock() should be constant ideally
(1millisecond should really be 1millisecond). Like I said in the last
email, change the scheduler to make it aware of the variable quantum
values.

Daniel

