Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZFZIlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZFZIlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZFZIlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:41:44 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:35774 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555AbZFZIlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:41:44 -0400
Subject: Re: kmemleak suggestion (long message)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <1246004879.27533.18.camel@penberg-laptop>
References: <20090625221816.GA3480@localdomain.by>
	 <20090626065923.GA14078@elte.hu>
	 <1246004740.30717.3.camel@pc1117.cambridge.arm.com>
	 <1246004879.27533.18.camel@penberg-laptop>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 26 Jun 2009 09:41:20 +0100
Message-Id: <1246005681.30717.8.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2009 08:41:21.0926 (UTC) FILETIME=[E1D65A60:01C9F639]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 11:27 +0300, Pekka Enberg wrote:
> On Fri, 2009-06-26 at 09:25 +0100, Catalin Marinas wrote:
> > BTW, this was questioned in the past as well - do we still need the
> > automatic scanning from a kernel thread? Can a user cron job just read
> > the kmemleak file?
> 
> I think the kernel thread makes sense so that we get an early warning in
> syslog.

If we keep the automatic scanning I could also change the code so that
the debug/kmemleak file only shows what was found during the thread
scanning rather than trigger a new scan (this could be forced with
something like echo "scan=now" > debug/kmemleak).

-- 
Catalin

