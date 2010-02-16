Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab0BPGSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 01:18:31 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45837 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab0BPGSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 01:18:30 -0500
Date: Tue, 16 Feb 2010 11:48:18 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Chris Friesen <cfriesen@nortel.com>, Avi Kivity <avi@redhat.com>,
       Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Mike Waychison <mikew@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC PATCH v1 0/4] CFS Bandwidth Control
Message-ID: <20100216061818.GB3492@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20100213025417.23325.90048.stgit@kitami.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100213025417.23325.90048.stgit@kitami.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 06:54:52PM -0800, Paul Turner wrote:
> Todo:
> -----
> - hierarchal nr_tasks_running accounting:
>   This is a deficiency currently shared with SCHED_RT rate limiting.  When
>   entities is throttled the running tasks it owns are not subtracted from 
>   rq->nr_running.  This then results in us missing idle_balance() due to
>   phantom tasks and load balancer weight per task calculations being
>   incorrect.
> 
>   This code adds complexity which was both increasing the complexity of the
>   initial review for this patchset and truly probably best reviewed
>   independently of this feature's scope.  To that end we'll post a separate
>   patch for this issue against the current RT rate-limiting code and merge any 
>   converged on approach here as appropriate.

I had tried updating rq->nr_running in my v2 patchset
(http://lkml.org/lkml/2009/9/30/117, http://lkml.org/lkml/2009/9/30/119)
But since I felt that it added a lot of complexity, I removed it
subsequently in v3 (http://lkml.org/lkml/2009/11/9/65) and kept it similar
to RT.

> 
> - throttle statistics:
>   Some statistics regarding the frequency and duration of throttling
>   definitely in order.

Please take a look at some of the throttling related stats I am collecting
in my patchset.

Regards,
Bharata.

