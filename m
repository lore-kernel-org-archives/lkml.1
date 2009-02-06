Return-Path: <linux-kernel-owner+w=401wt.eu-S1758511AbZBFJf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbZBFJf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbZBFJfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:35:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:34043 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbZBFJfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:35:41 -0500
Subject: Re: [PATCH 2/4] nmi: add generic nmi tracking state
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <20090206065437.986292747@goodmis.org>
References: <20090206065352.940088243@goodmis.org>
	 <20090206065437.986292747@goodmis.org>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 10:34:51 +0100
Message-Id: <1233912891.4731.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 01:53 -0500, Steven Rostedt wrote:

> This code adds an in_nmi() macro that uses the current tasks preempt count
> to track when it is in NMI context. Other parts of the kernel can
> use this to determine if the context is in NMI context or not.
> 
> This code was inspired by the -rt patch in_nmi version that was
> written by Peter Zijlstra.

Which in turn I borrowed from Mathieu.


