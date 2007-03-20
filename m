Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbXCTW6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbXCTW6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbXCTW6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:58:43 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:43234 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752063AbXCTW6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:58:42 -0400
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so
	far
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Lee Revell <rlrevell@joe-job.com>, tglx@linutronix.de,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Len Brown <lenb@kernel.org>
In-Reply-To: <1174382141.1158.61.camel@laptopd505.fenrus.org>
References: <200703161230.03712.maximlevitsky@gmail.com>
	 <1174088686.13341.347.camel@localhost.localdomain>
	 <75b66ecd0703192204n503eb4d3g361064f66319dd4c@mail.gmail.com>
	 <1174368995.14239.3.camel@perkele>
	 <1174382141.1158.61.camel@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 18:58:40 -0400
Message-Id: <1174431520.6532.15.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-20-03 at 10:15 +0100, Arjan van de Ven wrote:

> disabling that is a BAD idea. I'm no fan of SMM myself, but it's there,
> and we have to live with it. Disabling it without knowing what it does
> on your system is madness.
> 

Like Lee said, for "debugging", mainly trying to resolve unexplained
long latencies.

I've had a laptop that caused latency spikes with the cpu fan was turn
on. I tried disabling SMI to diagnose the problem with no success.

My current system has a BIOS feature to control fans speed according to
temperature. I presume this must a SMI to work right?  In this case it
should be possible to find and disable the related SMI and replace the
fan control with a user space software.

Of course it's not wise to blindly disable SMIs as we don't precisely
know what they do. 


- Eric


