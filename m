Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbZBMENA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbZBMENA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 23:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbZBMEMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 23:12:49 -0500
Received: from gate.crashing.org ([63.228.1.57]:38312 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961AbZBMEMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 23:12:46 -0500
Subject: Re: [PATCH 2/7][RFC] powerpc64: port of the function graph tracer
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090212011342.880486000@goodmis.org>
References: <20090212011051.265346435@goodmis.org>
	 <20090212011342.880486000@goodmis.org>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 15:12:00 +1100
Message-Id: <1234498320.26036.33.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2009-02-11 at 20:10 -0500, Steven Rostedt wrote:
> 
> +# timers used by tracing
> +CFLAGS_REMOVE_time.o = -pg -mno-sched-epilog
>  endif

That means no tracing of the timer interrupts etc... maybe we should
just move the specific function that we don't want traced out to a
separate file ? 

Appart from that, it looks ok, though I might have missed something :-)

Cheers,
Ben.

