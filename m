Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbYKZHgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbYKZHgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 02:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYKZHgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 02:36:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51064 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbYKZHgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 02:36:02 -0500
Date: Wed, 26 Nov 2008 08:35:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org
Subject: Re: [PATCH] ftrace: Add a C/P state tracer to help power
	optimization
Message-ID: <20081126073553.GH26036@elte.hu>
References: <20081123125931.4afe16ca@infradead.org> <c62985530811231312u51650cbcm2cb7b4f5c60d064@mail.gmail.com> <20081123164958.21fae966@infradead.org> <c62985530811250325h63ba1a08j610eb0be5ed73a45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811250325h63ba1a08j610eb0be5ed73a45@mail.gmail.com>
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

> That looks good...

[...]
> 
> Just for curiosity, do you have an example of trace and/or graph 
> from this tracer?

Output looks like this:

# tracer: power
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
[   54.698035123] CSTATE: Going to C1 on cpu 0 for 0.000022629
[   54.698059987] CSTATE: Going to C1 on cpu 0 for 0.000074032
[   54.698191011] CSTATE: Going to C1 on cpu 0 for 0.000134655
[   54.698327901] CSTATE: Going to C1 on cpu 0 for 0.000276017
[   54.699178020] CSTATE: Going to C1 on cpu 8 for 0.001454114
[   54.698138489] CSTATE: Going to C1 on cpu 5 for 0.002507334
[   54.699079124] CSTATE: Going to C1 on cpu 4 for 0.001611677
[   54.698605873] CSTATE: Going to C1 on cpu 0 for 0.003998045
[   54.700276498] CSTATE: Going to C1 on cpu 10 for 0.003994971
[   54.700636045] CSTATE: Going to C1 on cpu 6 for 0.003993295
[   54.700637442] CSTATE: Going to C1 on cpu 2 for 0.003993295
[   54.700634648] CSTATE: Going to C1 on cpu 8 for 0.003998883

	Ingo
