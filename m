Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbYADJW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbYADJW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 04:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbYADJWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 04:22:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39296 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756315AbYADJWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 04:22:10 -0500
Date: Fri, 4 Jan 2008 10:22:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86] [14/16] Enable RDC321X subarch only on 32bit
Message-ID: <20080104092200.GK28740@elte.hu>
References: <20080103442.621670000@suse.de> <20080103154228.875B814DDD@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103154228.875B814DDD@wotan.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> @@ -295,6 +295,7 @@ config X86_RDC321X
>  	select X86_REBOOTFIXUPS
>  	select GENERIC_GPIO
>  	select LEDS_GPIO
> +	depends on X86_32

not applied - the RDC321X subarch already has that dependency:

config X86_RDC321X
        bool "RDC R-321x SoC"
        depends on X86_32

	Ingo
