Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbYFJFOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbYFJFOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 01:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYFJFOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 01:14:47 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:44156 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751096AbYFJFOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 01:14:46 -0400
Message-ID: <484E0DB4.4070508@linux.vnet.ibm.com>
Date: Tue, 10 Jun 2008 10:44:28 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrea Righi <righi.andrea@gmail.com>
CC: menage@google.com, matt@bluehost.com, roberto@unbit.it,
       randy.dunlap@oracle.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] cgroup: block device i/o bandwidth controller (v2)
References: <> <1212791250-32320-1-git-send-email-righi.andrea@gmail.com>
In-Reply-To: <1212791250-32320-1-git-send-email-righi.andrea@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> The goal of the i/o bandwidth controller is to improve i/o performance
> predictability and provide better QoS for different cgroups sharing the same
> block devices.
> 
> Respect to other priority/weight-based solutions the approach used by this
> controller is to explicitly choke applications' requests that directly (or
> indirectly) generate i/o activity in the system.
> 
> The direct bandwidth limiting method has the advantage of improving the
> performance predictability at the cost of reducing, in general, the overall
> performance of the system (in terms of throughput).
> 
> Detailed informations about design, its goal and usage are described in the
> documentation.
> 

I'll read through the documentation and comment.

> Tested against latest git (2.6.26-rc5).
> 
> The all-in-one patch can be found at:
> http://download.systemimager.org/~arighi/linux/patches/io-throttle/
> 

Cool! thanks for doing this, it's useful.

> Previous version and test report can be found here:
> http://lkml.org/lkml/2008/5/24/97


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
