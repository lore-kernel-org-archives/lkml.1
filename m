Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbZDQPmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbZDQPmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbZDQPmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:42:31 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:64418 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911AbZDQPma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:42:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlAFAFc96ElMQW1W/2dsb2JhbACBTs5kg30G
Date: Fri, 17 Apr 2009 11:42:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 2/3] RCU move trace defines to rcupdate_types.h
Message-ID: <20090417154228.GB15046@Krystal>
References: <20090417003755.276959950@polymtl.ca> <20090417003931.846405986@polymtl.ca> <49E7D701.9090407@goop.org> <alpine.DEB.2.00.0904162122250.20429@gandalf.stny.rr.com> <20090417014209.GA24956@Krystal> <49E81A63.7010700@goop.org> <20090417151646.GB13842@Krystal> <49E89FC1.70006@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49E89FC1.70006@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:33:51 up 48 days, 12:00,  3 users,  load average: 0.58, 0.74,
	0.64
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Mathieu Desnoyers wrote:
>> Given the simplicity of the preempt_disable/enable_notrace found in
>> preempt.h, we could move them to 
>>
>> include/preempt_types.h too, and that would solve all problems, wouldn't
>> it ?
>>   
>
> No, it still needs linux/thread_info.h -> asm/thread_info.h, which in  
> turn gets quite a lot of things on x86 (and would need to be audited in  
> each architecture).
>
>    J

Well, I think it's a good time to do some cleanup then. Why on earth
would thread_info.h be anything else than a "_types"-like header ?

If headers has become in such a state in the kernel, then IMHO the
solution is not to shove more out-of-line functions under the carpet,
but rather to do the cleanup.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
