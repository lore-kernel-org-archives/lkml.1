Return-Path: <linux-kernel-owner+w=401wt.eu-S1761687AbXKPWMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761687AbXKPWMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 17:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbXKPWMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 17:12:07 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47266 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757310AbXKPWMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:12:06 -0500
Date: Fri, 16 Nov 2007 14:12:04 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Micah Dowty <micah@vmware.com>
cc: Ingo Molnar <mingo@elte.hu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: High priority tasks break SMP balancer?
In-Reply-To: <20071116104801.GA4585@vmware.com>
Message-ID: <Pine.LNX.4.64.0711161410490.6633@schroedinger.engr.sgi.com>
References: <20071110001103.GD16250@vmware.com> <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com>
 <20071115191408.GA4914@vmware.com> <Pine.LNX.4.64.0711151206370.28639@schroedinger.engr.sgi.com>
 <20071115202425.GC4914@vmware.com> <Pine.LNX.4.64.0711151328090.29711@schroedinger.engr.sgi.com>
 <20071115213510.GA16079@vmware.com> <Pine.LNX.4.64.0711151830260.31691@schroedinger.engr.sgi.com>
 <20071116024408.GA20322@vmware.com> <20071116060700.GD16273@elte.hu>
 <20071116104801.GA4585@vmware.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007, Micah Dowty wrote:

> 2.6.17 -
> 2.6.19 -
> 2.6.19.7 -
> 2.6.20 +
> 2.6.21 +
> 2.6.22 -
> 2.6.23.1 +
> 
> Here a "-" means that the problem does not occur (my test program uses
> 100% of both CPUs) and a "+" means that the test program leaves one
> CPU mostly idle.
> 
> Unless I've made a mistake, 2.6.22 seems like the outlier rather than
> 2.6.23. Is this inconsistent with the scheduler tick hypothesis?

Siddha fixed an issue with the jiffy accounting in for the softirq 
approach in.22 (vague recall maybe not exactly that version). This may be 
consistent with an issue that was fixed and now surfaces because of 
something else.

