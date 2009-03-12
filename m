Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZCLNxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZCLNxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbZCLNxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:53:41 -0400
Received: from mga05.intel.com ([192.55.52.89]:37586 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752866AbZCLNxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:53:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,350,1233561600"; 
   d="scan'208";a="672388954"
Message-ID: <49B913DC.6040807@linux.intel.com>
Date: Thu, 12 Mar 2009 06:53:32 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       arjan@linux.intel.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/futexes] futex: use current->time_slack_ns for rt tasks
 too
References: <20090312075559.9856.28822.stgit@Aeon> <tip-16f4993f4e9860715918efd4eeac928f8de1218b@git.kernel.org>
In-Reply-To: <tip-16f4993f4e9860715918efd4eeac928f8de1218b@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
> Commit-ID:  16f4993f4e9860715918efd4eeac928f8de1218b
> Gitweb:     http://git.kernel.org/tip/16f4993f4e9860715918efd4eeac928f8de1218b
> Author:     "Darren Hart" <dvhltc@us.ibm.com>
> AuthorDate: Thu, 12 Mar 2009 00:55:59 -0700
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 12 Mar 2009 11:20:57 +0100
> 
> futex: use current->time_slack_ns for rt tasks too
> 
> RT tasks should set their timer slack to 0 on their own.  This
> patch removes the 'if (rt_task()) slack = 0;' block in
> futex_wait.

Hi,

can you explain the rationale for this reasoning?

