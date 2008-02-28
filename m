Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbYB1U0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbYB1U0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757617AbYB1U0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:26:11 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22375 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbYB1U0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:26:09 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5241"; a="989061"
Message-ID: <47C718DE.9020107@qualcomm.com>
Date: Thu, 28 Feb 2008 12:26:06 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
References: <20080227222103.673194000@chello.nl>	<20080228075010.GA28781@elte.hu>	<20080228020808.3fd22f77.pj@sgi.com>	<20080228090847.GA1133@elte.hu>	<20080228031710.3405e405.pj@sgi.com>	<20080228104637.GA9129@elte.hu>	<47C7155C.5060607@qualcomm.com> <20080228141339.b83ae00f.pj@sgi.com>
In-Reply-To: <20080228141339.b83ae00f.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Jackson wrote:
> Max K wrote:
>> I like the concept of the "boot" set. But we still need a separate "system"
>> flag. Users should not have to move cpu back into the "boot" set to allow for
>> kernel (irqs, etc) activity on it. And it's just more explicit and clear that way.
> 
> Good point -- a "boot" cpuset might be 4 CPUs out of 256 CPUs, just for running
> the classic Unix load (daemons, init, login, ...).  But irq's might need to go
> to most CPUs, except for some (dare I use the word) isolated CPUs.
> 

btw Can you send me those init scripts that you mentioned. ie Those that
create "boot" set from userspace.

Max
