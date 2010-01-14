Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784Ab0ANWuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab0ANWuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228Ab0ANWuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:50:16 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42956 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab0ANWuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:50:13 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Jim Keniston <jkenisto@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263467394.4244.291.camel@laptop>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <1263467394.4244.291.camel@laptop>
Content-Type: text/plain
Date: Thu, 14 Jan 2010 14:49:40 -0800
Message-Id: <1263509380.4875.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2010-01-14 at 12:09 +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-11 at 17:55 +0530, Srikar Dronamraju wrote:
> > 
> > Uprobes Infrastructure enables user to dynamically establish
> > probepoints in user applications and collect information by executing
> > a handler functions when the probepoints are hit.
> > Please refer Documentation/uprobes.txt for more details.
> > 
> > This patch provides the core implementation of uprobes.
> > This patch builds on utrace infrastructure.
> > 
> > You need to follow this up with the uprobes patch for your
> > architecture. 
> 
> So all this is basically some glue between what you call ubp (the real
> userspace breakpoint stuff) and utrace? Or does it do more?
> 

My reply in
http://lkml.indiana.edu/hypermail/linux/kernel/1001.1/02483.html
addresses this.

Jim

