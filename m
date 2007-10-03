Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbXJCJjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbXJCJjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 05:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbXJCJj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 05:39:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41740 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752869AbXJCJj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 05:39:28 -0400
Date: Wed, 3 Oct 2007 02:39:24 -0700
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: nickpiggin@yahoo.com.au, akpm@linux-foundation.org, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, cpw@sgi.com
Subject: Re: [patch] sched: fix sched-domains partitioning by cpusets
Message-Id: <20071003023924.c4c5b2ef.pj@sgi.com>
In-Reply-To: <20071003093517.GA22558@elte.hu>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<20071003062240.GA19027@elte.hu>
	<20071002235615.6e8cd007.pj@sgi.com>
	<200710030146.30162.nickpiggin@yahoo.com.au>
	<20071003022108.5a8e310e.pj@sgi.com>
	<20071003093517.GA22558@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> in any case i'd like to see the externally visible API get in foremost - 
> and there now seems to be agreement about that. (yay!) Any internal 
> shaping of APIs can be done flexibly between cpusets and the scheduler.

Yup - though Nick and I will have to agree to -some- internal interface
between the cpuset and sched code, at least for the moment.

At least, if we thrash about on this, we won't be changing the externally
visible API around.  We'll just continue driving Andrew nuts, not our
users - that's an improvement.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
