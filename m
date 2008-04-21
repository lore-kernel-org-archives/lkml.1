Return-Path: <linux-kernel-owner+w=401wt.eu-S1758827AbYDUTDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbYDUTDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYDUTD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:03:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42219 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbYDUTD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:03:27 -0400
Date: Mon, 21 Apr 2008 21:03:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix kernel rodata NX setting
Message-ID: <20080421190312.GB1061@elte.hu>
References: <20080420000657.20ba6b4b@daedalus.pq.iki.fi> <20080420005208.12ad32fd@daedalus.pq.iki.fi> <20080419215826.GC2831@Krystal> <20080420014206.5cd61d4a@daedalus.pq.iki.fi> <20080420000509.GA7496@Krystal> <20080420101408.518b21b4@daedalus.pq.iki.fi> <20080420194440.GA15319@Krystal> <20080420231838.21eaf426@daedalus.pq.iki.fi> <20080420202533.GA16538@Krystal> <20080421214824.0c5dc637@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421214824.0c5dc637@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0806]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Paalanen <pq@iki.fi> wrote:

> From 35922163c8054bd8d12df78ebae6a6a603760206 Mon Sep 17 00:00:00 2001
> From: Pekka Paalanen <pq@iki.fi>
> Date: Mon, 21 Apr 2008 21:36:09 +0300
> Subject: [PATCH] x86_64: fix kernel rodata NX setting
> 
> Without CONFIG_DYNAMIC_FTRACE, mark_rodata_ro() would mark a wrong 
> number of pages as no-execute. The bug was introduced in the patch 
> "ftrace: dont write protect kernel text". The symptom was machine 
> reboot after a CPU hotplug.

thanks Pekka, nice fix!

	Ingo
