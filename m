Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbYJBMCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbYJBMCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 08:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbYJBMCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 08:02:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47057 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443AbYJBMCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 08:02:42 -0400
Date: Thu, 2 Oct 2008 14:02:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip 2/2] Tracing/fastboot: Get the initcall name
	before it disappears
Message-ID: <20081002120231.GB14322@elte.hu>
References: <48E4AFCD.9080004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E4AFCD.9080004@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0084]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> After some initcall traces, some initcall names may be inconsistent.
> That's because these functions will disappear from the .init section
> and also their name from the symbols table.
> So we have to copy the name of the function in a buffer large enough
> during the trace appending. It is not costly for the ring_buffer because
> the number of initcall entries is commonly not really large.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/tracing/fastboot, thanks Frederic,

	Ingo
