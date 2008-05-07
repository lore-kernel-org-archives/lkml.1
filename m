Return-Path: <linux-kernel-owner+w=401wt.eu-S1759611AbYEGJSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbYEGJSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 05:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbYEGJSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 05:18:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50676 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbYEGJR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 05:17:59 -0400
Date: Wed, 7 May 2008 11:17:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080507091748.GB30645@elte.hu>
References: <1210039590.3453.18.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210039590.3453.18.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> Comparing with 2.6.25, volanoMark has big regression with kernel 
> 2.6.26-rc1. It's about 50% on my 8-core stoakley, 16-core tigerton, 
> and Itanium Montecito.
> 
> With bisect, I located below patch.

thanks Yanmin, i've queued up your patch that reverts this change.

	Ingo
