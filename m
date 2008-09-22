Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbYIVKMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbYIVKMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYIVKLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:11:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55010 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbYIVKLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:11:52 -0400
Date: Mon, 22 Sep 2008 12:11:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: use platform_device_register_simple()
Message-ID: <20080922101137.GA27526@elte.hu>
References: <20080921142538.GA8790@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080921142538.GA8790@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0278]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Akinobu Mita <akinobu.mita@gmail.com> wrote:

> Cleanup pcspeaker.c

> -	pd = platform_device_alloc("pcspkr", -1);
> +	pd = platform_device_register_simple("pcspkr", -1, NULL, 0);

applied to tip/x86/cleanups, thanks!

	Ingo
