Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbYGNJiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbYGNJiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 05:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbYGNJiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 05:38:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55095 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbYGNJiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 05:38:08 -0400
Subject: Re: [PATCH] ftrace: Documentation
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jon Masters <jonathan@jonmasters.org>
In-Reply-To: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 11:38:26 +0200
Message-Id: <1216028306.12595.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-10 at 12:46 -0400, Steven Rostedt wrote:

> +  tracing_cpumask : This is a mask that lets the user only trace
> +		on specified CPUS. The format is a hex string
> +		representing the CPUS.

There is a parser and other goodies in the cpuset infrastructure, stuff
like that is needed when NR_CPUS > 32,64



