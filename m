Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbYEJN0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbYEJN0a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 09:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbYEJN0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 09:26:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:34464 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504AbYEJN0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 09:26:22 -0400
In-Reply-To: <Pine.SOC.4.64.0805101448580.8450@math.ut.ee>
References: <Pine.SOC.4.64.0805101448580.8450@math.ut.ee>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <2b70b1438132c0ff12583c7bf9d96cc1@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: ppc compile failure (__flush_icache_range etc undeclared)
Date: Sat, 10 May 2008 15:26:07 +0200
To: Meelis Roos <mroos@linux.ee>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Tried 2.6.26-rc1+git on ppc (arch/ppc, PReP subarch) and got this:
>
> arch/ppc/kernel/ppc_ksyms.c: At top level:
> arch/ppc/kernel/ppc_ksyms.c:152: error: '__flush_icache_range' 
> undeclared here (not in a function)

That's fixed by [2/3] in 
http://ozlabs.org/pipermail/linuxppc-dev/2008-May/056010.html


Segher

