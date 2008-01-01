Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYAAPXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYAAPXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbYAAPXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:23:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58307 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbYAAPXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:23:05 -0500
Date: Tue, 1 Jan 2008 16:22:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier@gentoo.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: asm-x86/byteorder.h: clean up for userspace
Message-ID: <20080101152241.GF4434@elte.hu>
References: <200712311312.46450.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712311312.46450.vapier@gentoo.org>
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


* Mike Frysinger <vapier@gentoo.org> wrote:

> Since asm-x86/byteorder.h is exported to userspace, use __asm__ rather 
> than asm in its code.

thanks Mike, i have applied your patch to x86.git - as a fix to be 
pushed into 2.6.24.

	Ingo
