Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbXERToi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbXERToi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 15:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbXERTob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 15:44:31 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35945 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754964AbXERToa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 15:44:30 -0400
Date: Fri, 18 May 2007 12:44:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Frank Sorenson <frank@tuxrocks.com>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v5
In-Reply-To: <464D23CC.1040906@tuxrocks.com>
Message-ID: <Pine.LNX.4.64.0705181242520.12983@schroedinger.engr.sgi.com>
References: <1178485128.31213.98.camel@localhost.localdomain>
 <1179309789.3764.20.camel@chaos> <464B5FF7.5070701@tuxrocks.com>
 <464BD945.2070007@tuxrocks.com> <464CA90B.20100@tuxrocks.com>
 <Pine.LNX.4.64.0705171219140.3043@schroedinger.engr.sgi.com>
 <464D23CC.1040906@tuxrocks.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, Frank Sorenson wrote:

> > Please boot with slub_debug.
> 
> No debugging output at all.  Still hangs with only:
> 	Kernel alive
> 	Kernel direct mapping tables up to 100000000 @ 8000-d000

Hmmmm..... No other output? Could it be that early console output is not 
available? Try earlyprintk=xx? Try another platform that has working early 
printk support (x86_64 seems broken to me)?

