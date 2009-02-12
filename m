Return-Path: <linux-kernel-owner+w=401wt.eu-S1759299AbZBLOnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbZBLOnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 09:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbZBLOmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 09:42:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:32917 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444AbZBLOmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:42:52 -0500
Subject: Re: [patch] generic-ipi: remove kmalloc, cleanup
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <20090212143432.GA6056@nowhere>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <20090212005032.GA4788@nowhere> <20090212021257.GB4697@nowhere>
	 <20090212081801.GA22979@elte.hu> <20090212081923.GA26838@elte.hu>
	 <1234430564.23438.205.camel@twins> <20090212100756.GA12790@elte.hu>
	 <20090212143432.GA6056@nowhere>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 15:42:44 +0100
Message-Id: <1234449764.10603.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 15:34 +0100, Frederic Weisbecker wrote:
> 
> Would you prefer I test this one or wait for everybody agree a final
> version?

It'll work, but its not mergable upstream like this, it greatly
pessimizes the smp_function_call() performance.

