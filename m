Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbZEESbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbZEESbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZEESb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:31:26 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40905 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbZEESb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:31:26 -0400
Message-ID: <4A0085FC.2060200@linux.vnet.ibm.com>
Date: Tue, 05 May 2009 11:31:24 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] perf_counter: ioctl(PERF_COUNTER_IOC_RESET)
References: <20090505155020.309162852@chello.nl> <20090505155437.022272933@chello.nl>
In-Reply-To: <20090505155437.022272933@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Peter Zijlstra wrote:

> +static void perf_counter_reset(struct perf_counter *counter)
> +{
> +	atomic_set(&counter->count, 0);
> +}
> +


Thanks for posting a patch for this issue.

As Ingo said, I think the hardware counter needs to be reset as well as 
the value saved in the perf_counter struct.


Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
cjashfor@us.ibm.com


