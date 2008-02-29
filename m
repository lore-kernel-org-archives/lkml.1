Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbYB2Fwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbYB2Fwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 00:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYB2Fwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 00:52:39 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40849 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbYB2Fwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 00:52:38 -0500
Date: Fri, 29 Feb 2008 11:32:30 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>, balbir@linux.vnet.ibm.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, skumar@linux.vnet.ibm.com
Subject: Re: [patch 2/2] sched: allow cpuacct stats to be reset
Message-ID: <20080229060230.GC3806@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080229043242.110741439@linux.vnet.ibm.com> <20080229043751.555866685@linux.vnet.ibm.com> <6599ad830802282148g7f309995l450fc15074234cd7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830802282148g7f309995l450fc15074234cd7@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 09:48:51PM -0800, Paul Menage wrote:
> Can I suggest, in order to be more generic, that this patch instead
> set each CPU's counter to the written value divided by the number of
> CPUs? (Either forgetting the remainder, or spreading it among the
> first few CPUs).

Paul,
	When would you want to reset the counters to non-zero value?
What would be its usecase?

-- 
Regards,
vatsa
