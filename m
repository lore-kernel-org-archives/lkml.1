Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbZLHL0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbZLHL0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZLHL0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:26:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:49137 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056AbZLHL0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:26:12 -0500
Message-ID: <4B1E37F5.7060002@kernel.org>
Date: Tue, 08 Dec 2009 20:26:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
References: <1259726212-30259-1-git-send-email-tj@kernel.org>	 <1259726212-30259-5-git-send-email-tj@kernel.org>	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>	 <4B1C85D3.3080401@kernel.org> <1260174900.8223.1159.camel@laptop>	 <4B1CDA1C.3000802@kernel.org> <1260183278.8223.1500.camel@laptop>	 <4B1CE1E8.2070803@kernel.org>  <4B1E1130.9050108@kernel.org>	 <1260262963.3935.1002.camel@laptop>  <4B1E189B.1070204@kernel.org>	 <1260268453.3935.1106.camel@laptop> <1260268739.3935.1113.camel@laptop>
In-Reply-To: <1260268739.3935.1113.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/08/2009 07:38 PM, Peter Zijlstra wrote:
> More confusion, kthread_bind() doesn't even use set_cpus_allowed() so it
> wouldn't have hit any of that crap.

kthread_bind() can't be used safely unless cpu up/down is synchronized
out some way.

Thanks.

-- 
tejun
