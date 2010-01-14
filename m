Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575Ab0ANLMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab0ANLMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532Ab0ANLMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:12:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53482 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab0ANLMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:12:51 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: ananth@in.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100112081412.GD28425@in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <20100112053559.GL5243@nowhere>  <20100112081412.GD28425@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 12:12:30 +0100
Message-ID: <1263467550.4244.293.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 13:44 +0530, Ananth N Mavinakayanahalli wrote:
> 
> Well, I wonder if perf can ride on utrace's callbacks for the
> hook_task() for the clone/fork cases? 

Well it could, but using all of utrace to simply get simple callbacks
from copy_process() is just daft so we're not going to do that.

