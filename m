Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473Ab0ANLKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab0ANLKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436Ab0ANLKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:10:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:57642 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab0ANLKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:10:02 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 12:09:54 +0100
Message-ID: <1263467394.4244.291.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 17:55 +0530, Srikar Dronamraju wrote:
> 
> Uprobes Infrastructure enables user to dynamically establish
> probepoints in user applications and collect information by executing
> a handler functions when the probepoints are hit.
> Please refer Documentation/uprobes.txt for more details.
> 
> This patch provides the core implementation of uprobes.
> This patch builds on utrace infrastructure.
> 
> You need to follow this up with the uprobes patch for your
> architecture. 

So all this is basically some glue between what you call ubp (the real
userspace breakpoint stuff) and utrace? Or does it do more?

