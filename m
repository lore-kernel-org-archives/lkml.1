Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbZDGVzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbZDGVzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761410AbZDGVz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:55:29 -0400
Received: from gw.goop.org ([64.81.55.164]:44367 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761062AbZDGVz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:55:29 -0400
Message-ID: <49DBCB8D.7030509@goop.org>
Date: Tue, 07 Apr 2009 14:54:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: x86@kernel.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, nickpiggin@yahoo.com.au, tglx@linutronix.de,
       jeremy.fitzhardinge@citrix.com
Subject: Re: [PATCH 7/8] mm: allow preemption in apply_to_pte_range
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>	<1238176963-21093-8-git-send-email-jeremy@goop.org> <20090407143833.a6841a8b.akpm@linux-foundation.org>
In-Reply-To: <20090407143833.a6841a8b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> So across the aptch series the aggregate change to mm/ is nil, and this
> is wholly an x86 patch series?
>
>   

Functionally, yes.  I also changed the name of the 
arch_enter_lazy_cpu_mode() -> arch_start_context_switch() which affects 
kernel/sched.c:context_switch(), but it is just a name update (which 
also required an asm-frv update, which defines its own no-op version of 
the macro rather than using the default no-op one, for some reason).

    J
