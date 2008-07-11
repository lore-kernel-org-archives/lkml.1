Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbYGKJTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbYGKJTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYGKJSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:18:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51341 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbYGKJSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:18:54 -0400
Date: Fri, 11 Jul 2008 11:18:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Glauber <jan.glauber@de.ibm.com>,
       Stefan Weinhuber <wein@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nohz: don't stop idle tick if softirqs are pending.
Message-ID: <20080711091802.GA437@elte.hu>
References: <20080711090922.GA4660@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711090922.GA4660@osiris.boeblingen.de.ibm.com>
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


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> Subject: [PATCH] nohz: don't stop idle tick if softirqs are pending.

applied to tip/timers/nohz, thanks Heiko.

> However there is no question that the drivers should be fixed. This 
> patch shouldn't be considered as a bug fix. It just is intended to 
> keep a system running even if device drivers are buggy.

agreed.

	Ingo
