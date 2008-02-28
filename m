Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbYB1MNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbYB1MNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 07:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbYB1MNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 07:13:17 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:61029 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973AbYB1MNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:13:16 -0500
Message-ID: <47C6A516.4070707@cfl.rr.com>
Date: Thu, 28 Feb 2008 07:12:06 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, Max Krasnyanskiy <maxk@qualcomm.com>,
       linux-kernel@vger.kernel.org,
       "markh@compro.net >> Mark Hounschell" <markh@compro.net>
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
References: <20080227222103.673194000@chello.nl>
In-Reply-To: <20080227222103.673194000@chello.nl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> My vision on the direction we should take wrt cpu isolation.
> 
> Next on the list would be figuring out a nice solution to the workqueue
> flush issue.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Is it now the intent, not only that I have to enable cpusets in the
kernel but I will also have to use them in userland to take advantage of
this.

And hot-plug too??

Can I predict that in the future that userland sched_setaffinity will be
taken away also and be forced to use cpusets?

And hot-plug too??

Mark
