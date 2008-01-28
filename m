Return-Path: <linux-kernel-owner+w=401wt.eu-S1764063AbYA1Xnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764063AbYA1Xnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYA1Xne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:43:34 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:12841 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763565AbYA1Xnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:43:32 -0500
Subject: Re: [CPUISOL] CPU isolation extensions
From: Daniel Walker <dwalker@mvista.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, Paul Jackson <pj@sgi.com>
In-Reply-To: <479E1FD4.5040606@qualcomm.com>
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
	 <1201511305.6149.30.camel@lappy>  <479E1FD4.5040606@qualcomm.com>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 15:41:45 -0800
Message-Id: <1201563706.2826.34.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-28 at 10:32 -0800, Max Krasnyanskiy wrote:
> Just this patches. RT patches cannot achieve what I needed. Even RTAI/Xenomai can't do that.
> For example I have separate tasks with hard deadlines that must be enforced in 50usec kind 
> of range and basically no idle time whatsoever. Just to give more background it's a wireless
> basestation with SW MAC/Scheduler. Another requirement is for the SW to know precise timing
> because SW. For example there is no way we can do predictable 1-2 usec sleeps. 
> So I wrote a user-space engine that does all this, it requires full control of the CPU ie minimal
> overhead from the kernel, just IPIs for memory management and that's basically it. When my legal 
> department lets me I'll do a presentation on this stuff at Linux RT conference or something. 

What kind of hardware are you doing this on? Also I should note there is
HRT (High resolution timers) which provided microsecond level
granularity ..

Daniel

