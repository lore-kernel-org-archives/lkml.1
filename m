Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbYE3EYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbYE3EYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYE3EYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:24:13 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49330 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbYE3EYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:24:12 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5306"; a="3516027"
Message-ID: <483F8178.7040300@qualcomm.com>
Date: Thu, 29 May 2008 21:24:24 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org
Subject: Re: [PATCH] sched: Give cpusets exclusive control over sched domains
 (ie remove cpu_isolated_map)
References: <1212085023-22284-1-git-send-email-maxk@qualcomm.com>	<1212085023-22284-2-git-send-email-maxk@qualcomm.com>	<1212085023-22284-3-git-send-email-maxk@qualcomm.com>	<20080529173759.ccbaf8ef.pj@sgi.com>	<483F3559.1030806@qualcomm.com> <20080529191211.080ec5cf.pj@sgi.com>
In-Reply-To: <20080529191211.080ec5cf.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Jackson wrote:
> Max wrote:
>> btw I suppose you missed my reply.
> 
> I did not see your reply.  Did you send it to me or lkml?
http://marc.info/?l=linux-kernel&m=121207910616332&w=2

>> Also Ingo at some point accepted a patch from Peter
>> that partially removed the isolated map.
> 
> Reference?  Did it remove the boot parameter isolcpus= ?
Yes it removed boot param. I cannot seem to come up with the right search
string. And the sched-devel git tree is gone.

> My concern is removing user visible features, without
> good reason and careful consideration and some planning.
I understand. How would you plan for this ?
----


Did you get a chance to look at patch that addresses hotplug/domain issues ?

Max
