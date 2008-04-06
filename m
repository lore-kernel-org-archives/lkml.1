Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbYDFG0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbYDFG0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 02:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbYDFG0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 02:26:38 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:42579 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYDFG0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 02:26:38 -0400
Message-ID: <47F86CE3.9080705@linux.vnet.ibm.com>
Date: Sun, 06 Apr 2008 11:55:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Balaji Rao <balajirrao@gmail.com>
CC: linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       dhaval@linux.vnet.ibm.com, balbir@in.ibm.com, menage@google.com,
       a.p.zijlstra@chello.nl, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][-mm] [0/2] Basic stats for cgroups V2
References: <200804052339.42474.balajirrao@gmail.com>
In-Reply-To: <200804052339.42474.balajirrao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balaji Rao wrote:
> V1->V2
> - Fixed a possible race in cpu_cgroup_read_stat. Thank you Paul for pointing this out.
> - A few other naming changes.
> 
> This patchset is a first step towards implementing stats for cgroup 
> subsystems. Only a few trivial stats for cpu and memory resource controller 
> have been implemented for now. Please provide comments on the general 
> direction and any suggestions on how you would like the cgroupstats framework 
> to be implemented.
> 
> roadmap
> --------
> implement a generic statistics framework for cgroups,
> unification with taskstats/netlink interface,
> add more statistics
> 

I like the roadmap and the patches. We need these statistics quite urgently. We
have lot of control and some statistics. We need more statistics to help make
the decision making (resizing, moving task, etc.) easier


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
