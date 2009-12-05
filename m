Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZLENEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZLENEu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 08:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbZLENEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 08:04:48 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45837 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbZLENEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 08:04:48 -0500
Date: Sat, 5 Dec 2009 18:34:46 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v4 PATCH 2/7] sched: Bandwidth initialization for fair
	task groups
Message-ID: <20091205130446.GB6204@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20091117143306.GK17335@in.ibm.com> <20091117143439.GM17335@in.ibm.com> <1259942997.17907.896.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259942997.17907.896.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 05:09:57PM +0100, Peter Zijlstra wrote:
> On Tue, 2009-11-17 at 20:04 +0530, Bharata B Rao wrote:
> > +/*
> > + * TODO: Check if this kind of timer setup is sufficient for cfs or
> > + * should we do what rt is doing.
> > + */
> > +static void start_cfs_bandwidth(struct task_group *tg)
> 
> is there a reason not to do as rt does?

Not really, rt seems to have an elaborate mechanism to check for overruns etc.
I was in two minds if I need to have the same for cfs, may be I will follow
rt here also.

Regards,
Bharata.
