Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbYKRKM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbYKRKM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 05:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYKRKMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 05:12:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55490 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbYKRKMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 05:12:49 -0500
Date: Tue, 18 Nov 2008 11:12:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Noonan <steven@uplinklabs.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing/ftrace: make nop tracer using tracer flags
Message-ID: <20081118101242.GL17838@elte.hu>
References: <4920D494.1010108@gmail.com> <f488382f0811161836n30ed40a7tcc9a32dac4b1c3ba@mail.gmail.com> <4920DE25.6050802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4920DE25.6050802@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Steven Noonan a écrit :
> > I'd like these #defines and structs moved to just after the #includes,
> > for cleanliness.
> 
> You're right I just corrected it in this V2.
> 
>  
> > Other than the change noted above, I think it looks good.
> > 
> > Acked-by: Steven Noonan <steven@uplinklabs.net>
> 
> Thanks!
> 
> Here is the V2:

thanks.

Steve, what's your take on this method of allowing extensions to 
tracer plugins? I've put Frederic's commits into tip/tracing/options, 
but have not merged them into tip/master yet.

	Ingo
