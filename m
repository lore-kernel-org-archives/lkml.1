Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYKFGYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYKFGYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYKFGYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:24:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35812 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbYKFGYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:24:33 -0500
Date: Thu, 6 Nov 2008 07:24:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Don't allow nr_irqs > NR_IRQS
Message-ID: <20081106062423.GB6384@elte.hu>
References: <1225819102.3074.15.camel@achroite> <1225886687.3074.59.camel@achroite>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1225886687.3074.59.camel@achroite>
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


* Ben Hutchings <bhutchings@solarflare.com> wrote:

> On some systems probe_nr_irqs() can return a value larger than 
> NR_IRQS.  This will lead to probe_irq_on() overrunning the irq_desc 
> array.
> 
> Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>

> ﻿ I hit this when running net-next-2.6 (close to 
> 2.6.28-rc3) on a Supermicro dual Xeon system.  NR_IRQS is 224 but 
> probe_nr_irqs() detects 5 IOAPICs and returns 240.  Here are the log 
> messages:

applied to tip/x86/urgent, thanks Ben!

	Ingo
