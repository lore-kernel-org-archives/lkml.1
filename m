Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbZDQP1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbZDQP1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759460AbZDQP1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:27:00 -0400
Received: from gw.goop.org ([64.81.55.164]:49647 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbZDQP07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:26:59 -0400
Message-ID: <49E89FC1.70006@goop.org>
Date: Fri, 17 Apr 2009 08:26:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 2/3] RCU move trace defines to rcupdate_types.h
References: <20090417003755.276959950@polymtl.ca> <20090417003931.846405986@polymtl.ca> <49E7D701.9090407@goop.org> <alpine.DEB.2.00.0904162122250.20429@gandalf.stny.rr.com> <20090417014209.GA24956@Krystal> <49E81A63.7010700@goop.org> <20090417151646.GB13842@Krystal>
In-Reply-To: <20090417151646.GB13842@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Given the simplicity of the preempt_disable/enable_notrace found in
> preempt.h, we could move them to 
>
> include/preempt_types.h too, and that would solve all problems, wouldn't
> it ?
>   

No, it still needs linux/thread_info.h -> asm/thread_info.h, which in 
turn gets quite a lot of things on x86 (and would need to be audited in 
each architecture).

    J
