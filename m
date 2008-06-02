Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYFBPXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYFBPXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYFBPXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:23:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40043 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751297AbYFBPXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:23:44 -0400
Date: Mon, 2 Jun 2008 10:23:40 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rdunlap@xenotime.net
Subject: Re: [PATCH] genirq: Expose default irq affinity mask (take 3)
Message-Id: <20080602102340.71d2399f.pj@sgi.com>
In-Reply-To: <1212084172-21459-1-git-send-email-maxk@qualcomm.com>
References: <1212084172-21459-1-git-send-email-maxk@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max,

I realized, when reading this again, that the default masks
are not ffffffff.  That's the default only on systems with
no more than 32 CPUs.  Rather I suspect that the default is
CPU_MASK_ALL.  Indeed, your patch has:

   cpumask_t irq_default_affinity = CPU_MASK_ALL;

This affects a few mentions of ffffffff in the Docs.

Otherwise looks good - thanks.

Acked-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
