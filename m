Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbXFNNJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbXFNNJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 09:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbXFNNJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 09:09:16 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:58579 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbXFNNJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 09:09:15 -0400
Date: Thu, 14 Jun 2007 09:08:34 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Darren Hart <dvhltc@us.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH RT] fix migrating softirq [cause of network hang]
In-Reply-To: <200706140002.17411.dvhltc@us.ibm.com>
Message-ID: <Pine.LNX.4.58.0706140907570.32607@gandalf.stny.rr.com>
References: <1181738836.10408.54.camel@localhost.localdomain>
 <200706140002.17411.dvhltc@us.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007, Darren Hart wrote:

> On Wednesday 13 June 2007 05:47:16 Steven Rostedt wrote:
>
> >
> > I'm assuming that this fix may fix other bugs too.
> >
>
> I ran 2.6.21-rt10 + this patch with kernbench and then loops building a kernel
> (which would previously rapidly exhaust memory).  It successfully built 400
> kernels with "make -j 32" on an 8 opteron machine with 8 GB of RAM and has so
> far completed 25 "make -j" on the same system.  Looks like a winner to me so
> far.
>


This is great news! Darren (and team), thanks a lot for testing it.

-- Steve

