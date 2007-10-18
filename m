Return-Path: <linux-kernel-owner+w=401wt.eu-S1764315AbXJRTEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764315AbXJRTEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759419AbXJRTEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:04:15 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47058 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759244AbXJRTEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:04:14 -0400
Date: Fri, 19 Oct 2007 00:42:56 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, pbadari@us.ibm.com,
       dhaval@linux.vnet.ibm.com
Subject: Re: Buggy idle time reported in /proc/uptime for SMP systems?
Message-ID: <20071018191256.GA29046@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071018162513.GA19214@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018162513.GA19214@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 09:55:13PM +0530, Srivatsa Vaddagiri wrote:
> The idle time reported in /proc/uptime (2nd field) seems to be the idle
> time of only CPU0. Shouldn't it reflect the total idle time on a SMP system? 
> Do folks agree that it is a bug that needs to be fixed? If so, will send
> a patch ...

On further reflection, it doesn't sound buggy. Reporting idle time across all
cpus in /proc/uptime will cause idle time > uptime, which will be odd. I
guess if anyone wants strict idle time from all cpus, they can always
look at /proc/stat.

> Fyi, I see patches submitted to fix this way back in 2001
> [http://lkml.org/lkml/2001/3/17/55], but don't think they made in ..

-- 
Regards,
vatsa
