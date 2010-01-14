Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152Ab0ANMR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab0ANMR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 07:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839Ab0ANMR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 07:17:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab0ANMR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 07:17:26 -0500
Subject: Re: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
From: Mark Wielaard <mjw@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263468575.4244.306.camel@laptop>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com>
	 <1263468191.4244.300.camel@laptop>  <1263468575.4244.306.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 13:16:51 +0100
Message-ID: <1263471411.23962.13.camel@springer.wildebeest.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 12:29 +0100, Peter Zijlstra wrote:
> On Thu, 2010-01-14 at 12:23 +0100, Peter Zijlstra wrote:
> > On Mon, 2010-01-11 at 17:56 +0530, Srikar Dronamraju wrote:
> > > This patch implements ftrace plugin for uprobes.
> > 
> > Right, like others have said, trace events is a much saner interface.
> > 
> > So the easiest way I can see that working is to register uprobes against
> > a file (not a pid).
> 
> Just to clarify, this means you can do things like:
> 
>  p:uprobe_event dso:symbol[+offs]
> 
> Irrespective of whether there are any current user of that file.

Yes, that is a good idea, you can then also refine that with a filter on
a target pid. That is what systemtap also does, you define files
(whether they are executables or shared libraries, etc) plus
symbols/offsets/etc as targets and monitor when they get mapped in
(either system wide, per executable or pid based).

Cheers,

Mark

