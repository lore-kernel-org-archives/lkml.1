Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbXKBHuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbXKBHuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 03:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbXKBHuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 03:50:01 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:40832 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbXKBHuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 03:50:00 -0400
Subject: Re: [PATCH] Restore deterministic CPU accounting on powerpc
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <18218.44089.274628.680088@cargo.ozlabs.ibm.com>
References: <18218.44089.274628.680088@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 02 Nov 2007 08:49:56 +0100
Message-Id: <1193989796.10694.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-02 at 15:48 +1100, Paul Mackerras wrote:
> This also lets us simplify the s390 code a bit; it means that the s390
> timer interrupt can now call update_process_times even when
> CONFIG_VIRT_CPU_ACCOUNTING is turned on, and can just implement a
> suitable account_process_tick().

Just tested on s390 with CONFIG_VIRT_CPU_ACCOUNTING=y. Works fine and it
is a nice cleanup of the s390 timer code. Thanks Paul.

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


