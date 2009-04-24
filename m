Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbZDXHMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbZDXHMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZDXHMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:12:21 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:49750 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZDXHMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:12:20 -0400
Message-ID: <49F16654.8040208@in.ibm.com>
Date: Fri, 24 Apr 2009 12:42:20 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linux-s390@vger.kernel.org
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: Next April 24: [S390] allmodconfig build failure (trace/events)
References: <20090424150456.ff35e4ea.sfr@canb.auug.org.au>
In-Reply-To: <20090424150456.ff35e4ea.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's next tree build(s390 allmodconfig) failed with

kernel/built-in.o: In function `trace_softirq_entry'
include/trace/events/irq.h:42: undefined reference to 
`__tracepoint_softirq_entry'
include/trace/events/irq.h:42: undefined reference to 
`__tracepoint_softirq_entry'
kernel/built-in.o: In function `trace_softirq_exit':
include/trace/events/irq.h:48: undefined reference to 
`__tracepoint_softirq_exit'
include/trace/events/irq.h:48: undefined reference to 
`__tracepoint_softirq_exit'

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

