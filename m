Return-Path: <linux-kernel-owner+w=401wt.eu-S1761972AbYEFMgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972AbYEFMgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYEFMgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:36:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40325 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258AbYEFMgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:36:35 -0400
Date: Tue, 6 May 2008 14:36:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH, minor] sched: check for SD_SERIALIZE atomically in
	rebalance_domains()
Message-ID: <20080506123622.GN32591@elte.hu>
References: <1210023979.6220.9.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210023979.6220.9.camel@earth>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> 
> Nothing really serious here, mainly just a matter of nit-picking :-/
> 
> 
> From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> Subject: sched: check for SD_SERIALIZE atomically in rebalance_domains()
>     
> For CONFIG_SCHED_DEBUG && CONFIG_SYSCT configs, sd->flags can be 
> altered while being manipulated in rebalance_domains(). Let's do an 
> atomic check. We rely here on the atomicity of read/write accesses for 
> aligned words.

applied, thanks Dmitry.

	Ingo
