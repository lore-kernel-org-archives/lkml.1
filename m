Return-Path: <linux-kernel-owner+w=401wt.eu-S1762714AbYB1ThA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762714AbYB1ThA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762188AbYB1Tgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:36:48 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9945 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079AbYB1Tgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:36:46 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5241"; a="986491"
Message-ID: <47C70D49.2060909@qualcomm.com>
Date: Thu, 28 Feb 2008 11:36:41 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 1/4] sched: remove isolcpus
References: <20080227222103.673194000@chello.nl>	 <20080227222542.056473000@chello.nl>  <47C5F8E0.3060708@qualcomm.com> <1204193985.6243.27.camel@lappy>
In-Reply-To: <1204193985.6243.27.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2008-02-27 at 15:57 -0800, Max Krasnyanskiy wrote:
>> Peter Zijlstra wrote:
>>
>>> cpu isolation doesn't offer anything over cpusets, hence remove it.
>> Works for me. That's what I suggested in my reply to your comments.
>> Here is the quote from the previous thread:
> 
> Dude, I've been pushing a cpuset interface from the get go.
Right. And you ended up with exact same solution for the map that represents
the CPUs that are isolated (or not isolated).
I was just saying that I was asking people how to integrate cpu_isolated_map
with cpusets, none of you guys acked or nacked it.

Max
