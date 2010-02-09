Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab0BIIzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 03:55:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55830 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab0BIIy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 03:54:59 -0500
Subject: Re: [RFC perf,x86] P4 PMU early draft
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100209042348.GA2558@brick.ozlabs.ibm.com>
References: <20100208184504.GB5130@lenovo>
	 <20100209042348.GA2558@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Feb 2010 09:54:31 +0100
Message-ID: <1265705671.11509.177.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-09 at 15:23 +1100, Paul Mackerras wrote:
> On Mon, Feb 08, 2010 at 09:45:04PM +0300, Cyrill Gorcunov wrote:
> 
> > The main problem in implementing P4 PMU is that it has much more
> > restrictions for event to MSR mapping. So to fit into current
> > perf_events model I made the following:
> 
> Is there somewhere accessible on the web where I can read about the P4
> PMU?  I'm interested to see if the constraint representation and
> search I used on the POWER processors would be applicable.

Mostly:

http://www.intel.com/Assets/PDF/manual/253669.pdf

Section 30.8 PERFORMANCE MONITORING (PROCESSORS
BASED ON INTEL NETBURST MICROARCHITECTURE)

Section 30.9 PERFORMANCE MONITORING AND INTEL HYPER-
THREADING TECHNOLOGY IN PROCESSORS BASED
ON INTEL NETBURST MICROARCHITECTURE

Section A.8 PENTIUM 4 AND INTEL XEON PROCESSOR PERFORMANCE-MONITORING
EVENTS


