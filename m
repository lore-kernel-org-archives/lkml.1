Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbYFBRzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbYFBRzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYFBRzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:55:01 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37104 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYFBRzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:55:00 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5308"; a="3438560"
Message-ID: <48443407.2080707@qualcomm.com>
Date: Mon, 02 Jun 2008 10:55:19 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org
Subject: Re: [PATCH] sched: CPU hotplug events must not destroy scheduler
 domains created by the cpusets
References: <1212085023-22284-1-git-send-email-maxk@qualcomm.com> <20080602101902.cf8cdf11.pj@sgi.com>
In-Reply-To: <20080602101902.cf8cdf11.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> I think this patch is ok --- though 

> (1) perhaps it should have been two patches, as it seems to fix two bugs, and 
I could split cpusets fix out I suppose.

> (2) I only managed to get my head about 80% of
> the way around this, so while I confident enough to Ack this one, I'm not
> as certain as I might be.
> 
> Acked-by: Paul Jackson <pj@sgi.com>
Thanx.

> I did see a couple of places where the code could be more clearly presented,
> and a couple of lines ending in space characters in *.c files (the Doc files
> are hopelessly failing this space terminator test, so I gave up on them.)
> [snip]
I'll fix the spaces and redo the scheduler parts based on your suggestions.
As usual, nice and thorough review. Thanx.

Max
