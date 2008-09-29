Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYI2QJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYI2QJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 12:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYI2QJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 12:09:51 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:34935 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYI2QJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 12:09:50 -0400
Message-ID: <48E0FDC5.1080500@nortel.com>
Date: Mon, 29 Sep 2008 10:09:41 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
       a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [PATCH] sched: minor optimizations in wake_affine and select_task_rq_fair
References: <20080929100227.GA21129@amitarora.in.ibm.com>
In-Reply-To: <20080929100227.GA21129@amitarora.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2008 16:09:42.0862 (UTC) FILETIME=[C882EEE0:01C9224D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit K. Arora wrote:
> Hello,
> 
> Please consider this patch. It makes a few minor changes to
> sched_fair.c.
> 
> 
> sched: Minor optimizations in wake_affine and select_task_rq_fair
> 
> This patch does following:
> o Reduces the number of arguments to wake_affine().

At what point is it cheaper to pass items as args rather than 
recalculating them?  If reducing the number of args is desirable, what 
about removing the "this_cpu" and "prev_cpu" args and recalculating them 
in wake_affine()?

Chris
