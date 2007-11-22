Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbXKVMBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbXKVMBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 07:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbXKVMBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 07:01:04 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:35923 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751506AbXKVMBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 07:01:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAIb+REdMROHU/2dsb2JhbACBWw
Date: Thu, 22 Nov 2007 07:00:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Mike Mason <mmlnx@us.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH] Linux Kernel Markers - Support Multiple Probes
Message-ID: <20071122120056.GA6134@Krystal>
References: <20071122034126.GA24898@Krystal> <20071122100658.GA2738@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071122100658.GA2738@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 06:57:19 up 18 days, 17:02,  3 users,  load average: 1.20, 0.81,
	0.67
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Wed, Nov 21, 2007 at 10:41:26PM -0500, Mathieu Desnoyers wrote:
> > RCU style multiple probes support for the Linux Kernel Markers.
> 
> Why would we want this?
> 

If we want to have more than one probe connected to a marker at a given
time (LTTng, or blktrace, ssytemtap) then we need this patch. Without it,
connecting a second probe handler to a marker will fail.

It allow us, for instance, to do interesting combinations :

Do standard tracing with LTTng and, eventually, to compute statistics
with SystemTAP, or to have a special trigger on an event that would call
a systemtap script which would stop flight recorder tracing.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
