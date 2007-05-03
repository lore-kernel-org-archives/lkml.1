Return-Path: <linux-kernel-owner+w=401wt.eu-S1031297AbXECNp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031297AbXECNp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031304AbXECNp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:45:28 -0400
Received: from [212.12.190.201] ([212.12.190.201]:33160 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031297AbXECNp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:45:27 -0400
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v7
Date: Thu, 3 May 2007 16:49:23 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200704300820.49078.a1426z@gawab.com> <200705031416.50928.a1426z@gawab.com> <20070503123655.GA705@elte.hu>
In-Reply-To: <20070503123655.GA705@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705031649.23331.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Al Boldi <a1426z@gawab.com> wrote:
> > [...] But I can still see these awful latency blips in the presence of
> > negatively niced chew.c at -10 and two chew.c's at nice 0. [...]
>
> of course: you asked for the two chew's to be treated like that and CFS
> delivered it! :-)
>
> nice -10 means the two chew's will get ~90+% of the CPU time, and all
> other nice 0 tasks will get <10% of CPU time.

Yes, but the latencies fluctuate wildly from 5ms to 
sched_granularity_ns*1000.  Isn't it possible to smooth this?


Thanks!

--
Al

