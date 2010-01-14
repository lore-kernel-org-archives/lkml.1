Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201Ab0ANLIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab0ANLIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884Ab0ANLIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:08:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58366 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab0ANLIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:08:44 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 12:08:09 +0100
Message-ID: <1263467289.4244.288.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 17:55 +0530, Srikar Dronamraju wrote:
> User Space Breakpoint Assistance Layer (UBP)
> 
> User space breakpointing Infrastructure provides kernel subsystems
> with architecture independent interface to establish breakpoints in
> user applications. This patch provides core implementation of ubp and
> also wrappers for architecture dependent methods.

So if this is the basic infrastructure to set userspace breakpoints,
then why not call this uprobe?

> UBP currently supports both single stepping inline and execution out
> of line strategies. Two different probepoints in the same process can
> have two different strategies.

maybe explain wth these are?

