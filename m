Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbZJWQcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbZJWQcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 12:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbZJWQcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 12:32:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60535 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbZJWQcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 12:32:07 -0400
Date: Fri, 23 Oct 2009 18:31:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Adrian Bunk <bunk@stusta.de>, Harvey Harrison <harvey.harrison@gmail.com>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       GeunSik Lim <leemgs1@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL v2,
	headers to Dual BSD/GPL
Message-ID: <20091023163147.GA22928@elte.hu>
References: <20091023160257.GA30447@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023160257.GA30447@Krystal>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi,
> 
> I would like to re-license the tracepoint.c/marker.c files from GPL 
> to:
> 
> * Dual LGPL v2.1/GPL v2 license.
> 
> And re-license tracepoint.h/marker.h to:
> 
> * Dual BSD/GPL v2 license.
> 
> The goal is to allow sharing code between the kernel tracer and UST 
> (User-Space Tracer) project, which is a LGPL v2.1 library. Tracepoint 
> and marker headers might need to be included by proprietary or BSD 
> applications, hence the dual BSD/GPL v2 license for these two.

We need a clean interface instead of some messy bindings - why do you 
need a different license to kernel/tracepoint.c?

	Ingo
