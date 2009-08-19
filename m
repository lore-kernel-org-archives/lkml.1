Return-Path: <linux-kernel-owner+w=401wt.eu-S1751593AbZHSLNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbZHSLNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 07:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZHSLNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 07:13:39 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:45644 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZHSLNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 07:13:38 -0400
Message-ID: <4A8BDE59.2010400@in.ibm.com>
Date: Wed, 19 Aug 2009 16:43:29 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-s390@vger.kernel.org
Subject: Next Aug 19: s390 build failure (arch/s390/kernel/built-in)
References: <20090819190233.86e78493.sfr@canb.auug.org.au>
In-Reply-To: <20090819190233.86e78493.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's next build failed on s390 with following errors.

  LD      .tmp_vmlinux1
arch/s390/kernel/built-in.o: In function `trace_syscall_exit':
include/trace/syscall.h:21: undefined reference to `__tracepoint_syscall_exit'
include/trace/syscall.h:21: undefined reference to `__tracepoint_syscall_exit'
arch/s390/kernel/built-in.o: In function `trace_syscall_enter':
include/trace/syscall.h:14: undefined reference to `__tracepoint_syscall_enter'
include/trace/syscall.h:14: undefined reference to `__tracepoint_syscall_enter'
make: *** [.tmp_vmlinux1] Error 1

thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

