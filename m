Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbYBADd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbYBADd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 22:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYBADds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 22:33:48 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:38923 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbYBADdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 22:33:47 -0500
Message-ID: <47A292D1.1040600@linux.vnet.ibm.com>
Date: Fri, 01 Feb 2008 09:02:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, Ingo Molnar <mingo@elte.hu>,
       containers@lists.osdl.org, dhaval@linux.vnet.ibm.com,
       Balbir Singh <balbir@in.ibm.com>, pj@sgi.com,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [RFC] Default child of a cgroup
References: <20080131024049.GA9544@linux.vnet.ibm.com> <6599ad830801311839x33cf2ebco9f501571fc129b11@mail.gmail.com>
In-Reply-To: <6599ad830801311839x33cf2ebco9f501571fc129b11@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:

[snip]
> BTW, I noticed this code in cpu_cgroup_create():
> 
>         /* we support only 1-level deep hierarchical scheduler atm */
>         if (cgrp->parent->parent)
>                 return ERR_PTR(-EINVAL);
> 
> Is anyone working on allowing more levels?
> 

Yes, Dhaval nad Vatsa are looking at removing that limitation.
This discussion is a side-effect of the multi-hierarchy discussion/implementation.

> Paul


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
