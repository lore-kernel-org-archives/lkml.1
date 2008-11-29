Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYK2OUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYK2OUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 09:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbYK2OT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 09:19:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54228 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYK2OT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 09:19:59 -0500
Date: Sat, 29 Nov 2008 15:19:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: adjustments of the
	trace informations
Message-ID: <20081129141945.GA10639@elte.hu>
References: <492F3076.7050104@gmail.com> <20081128091800.GA1725@elte.hu> <c62985530811280555m3b6eaa7fwb50bbe0f5c13bdd3@mail.gmail.com> <20081128141738.GE28138@elte.hu> <c62985530811281924t759b9c9as35333453b1664d96@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811281924t759b9c9as35333453b1664d96@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> > Another thing that would be nice is to separate out the "cpu)" 
> > printing bits into a helper function. Right now what exists cannot be 
> > used in a seq-manner, so i couldnt reuse it.
> >
> 
> Isn't it the case with print_graph_cpu() ?

yeah, that should be okay. I didnt use it in verif_pid() because it 
returns print_line_t - but i guess it would be better to fix verif_pid() 
to check for !ret instead of the ret += thing i added.

	Ingo
