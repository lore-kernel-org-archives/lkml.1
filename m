Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbXEWDkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbXEWDkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 23:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbXEWDjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 23:39:54 -0400
Received: from www.osadl.org ([213.239.205.134]:54531 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755711AbXEWDjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 23:39:53 -0400
Subject: Re: [PATCH -rt] ARM TLB flush fix: don't forget to re-enable
	preemption
From: Thomas Gleixner <tglx@linutronix.de>
To: Kevin Hilman <khilman@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20070522230128.891568116@mvista.com>
References: <20070522230128.891568116@mvista.com>
Content-Type: text/plain
Date: Wed, 23 May 2007 05:39:46 +0200
Message-Id: <1179891586.12708.135.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 16:01 -0700, Kevin Hilman wrote:
> Add a preempt_enable() to flush_tlb_kernel_page() since -rt4 patch
> adds a preempt_disable but no preempt_enable().
> 
> Signed-off-by: Kevin Hilman <khilman@mvista.com>

Good catch. Applied.

Thanks,

	tglx


