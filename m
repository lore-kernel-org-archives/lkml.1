Return-Path: <linux-kernel-owner+w=401wt.eu-S1751596AbXCNRAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbXCNRAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXCNRAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:00:05 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:24877 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbXCNRAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:00:01 -0400
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
In-Reply-To: <45F824BE.1060708@goop.org>
References: <45F6D1D0.6080905@goop.org>
	 <1173816769.22180.14.camel@localhost>  <45F70A71.9090205@goop.org>
	 <1173821224.1416.24.camel@dwalker1>  <45F71EA5.2090203@goop.org>
	 <1173837606.23595.32.camel@imap.mvista.com>  <45F79B9C.20609@goop.org>
	 <1173888673.3101.12.camel@imap.mvista.com>  <45F824BE.1060708@goop.org>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 09:59:55 -0700
Message-Id: <1173891595.3101.17.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 09:37 -0700, Jeremy Fitzhardinge wrote:
> Daniel Walker wrote:
> > Then your direction is wrong, sched_clock() should be constant ideally
> > (1millisecond should really be 1millisecond). 
> 
> Rather than repeating myself, I suggest you read my original post
> again.  But my point is that "I was runnable on a cpu for 1ms of real
> time" is a meaningless measurement: you want to measure "I ran for 1
> cpu-ms", which is a unit which depends on how work a particular CPU does
> in relationship to other CPUs on the system, or even itself at some
> previous time.

I understood, I just don't agree that you suggested modification are the
correct ones to make.

> > Like I said in the last
> > email, change the scheduler to make it aware of the variable quantum
> > values.
> 
> I suppose you could, but that seems more complex.  I think you could
> encode the same information in the measurement of how much work a cpu
> actually got done while a process was scheduled on it.

I know it's more complex, but that seems more like the "right" thing to
do.

Daniel

