Return-Path: <linux-kernel-owner+w=401wt.eu-S1762673AbXEPFu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762673AbXEPFu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 01:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761374AbXEPFuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 01:50:20 -0400
Received: from www.osadl.org ([213.239.205.134]:50669 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761286AbXEPFuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 01:50:19 -0400
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v4
From: Thomas Gleixner <tglx@linutronix.de>
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200705160023.55899.s0348365@sms.ed.ac.uk>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <200705142342.29994.s0348365@sms.ed.ac.uk> <1179217082.7074.47.camel@chaos>
	 <200705160023.55899.s0348365@sms.ed.ac.uk>
Content-Type: text/plain
Date: Wed, 16 May 2007 07:54:21 +0200
Message-Id: <1179294861.12838.47.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 00:23 +0100, Alistair John Strachan wrote:
> > - TSC calibration against PM-Timer
> 
> Working fine now, thanks a lot. Great latencies on usleep() now too, just what 
> I was looking for.
> 
> (BTW, with HRT (but not NO_HZ), does the HZ value have any effect on usleep() 
> (and friends) latencies?)

Not directly.

	tglx


