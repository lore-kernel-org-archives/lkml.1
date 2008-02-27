Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbYB0Kx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbYB0Kx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 05:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYB0KxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 05:53:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51464 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbYB0KxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 05:53:19 -0500
Date: Wed, 27 Feb 2008 11:53:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86] rdc321x: Kconfig options fixes for rdc321x
Message-ID: <20080227105307.GA21050@elte.hu>
References: <200802271136.42763.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802271136.42763.florian.fainelli@telecomint.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Florian Fainelli <florian.fainelli@telecomint.eu> wrote:

>  config ARCH_HIBERNATION_POSSIBLE
>  	def_bool y
> -	depends on !SMP || !X86_VOYAGER
> +	depends on !SMP || !(X86_VOYAGER || X86_RDC321X)

these many special conditions in the Kconfig space are way too ugly. 
(Also, i can see no reason why for example hibernation wouldnt be 
possible on rdc321x, it's a pure software concept ...)

	Ingo
