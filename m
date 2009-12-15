Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbZLOC74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbZLOC74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759082AbZLOC7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:59:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759077AbZLOC7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:59:54 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/utrace
Cc: Peter Zijlstra <peterz@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
In-Reply-To: Oleg Nesterov's message of  Monday, 14 December 2009 21:24:54 +0100 <20091214202454.GA16124@redhat.com>
References: <20091124200220.GA5828@redhat.com>
	<1259697242.1697.1075.camel@laptop>
	<20091214002533.3052519@magilla.sf.frob.com>
	<20091214170327.GA7666@redhat.com>
	<20091214194441.4D6BFE24E@magilla.sf.frob.com>
	<20091214202454.GA16124@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20091215025917.B6882D8@magilla.sf.frob.com>
Date: Mon, 14 Dec 2009 18:59:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> SIGCONT can wake up the TASK_STOPPED tracee. I don't think the tracer
> should ever rely on TASK_STOPPED (utrace never does). If the tracer
> needs the "really stopped" tracee we have UTRACE_STOP, and this means
> TASK_TRACED.

Ah, yes.  utrace_control(task,,UTRACE_STOP) while task is in TASK_STOPPED
means turning it into TASK_TRACED.


Thanks,
Roland
