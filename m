Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbYHUKf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbYHUKf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbYHUKft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:35:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40419 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428AbYHUKfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:35:48 -0400
Date: Thu, 21 Aug 2008 12:35:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH] x86, mmiotrace: silence section mismatch warning -
	leave_uniprocessor
Message-ID: <20080821103538.GF19452@elte.hu>
References: <1219259268-5868-1-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219259268-5868-1-git-send-email-marcin.slusarz@gmail.com>
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


* Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> WARNING: vmlinux.o(.text+0x180af): Section mismatch in reference from the function leave_uniprocessor() to the function .cpuinit.text:cpu_up()
> The function leave_uniprocessor() references
> the function __cpuinit cpu_up().
> This is often because leave_uniprocessor lacks a __cpuinit
> annotation or the annotation of cpu_up is wrong.
> 
> leave_uniprocessor calls cpu_up only when CONFIG_HOTPLUG_CPU is set,
> so it can be safely annotated as __ref

applied to tip/x86/urgent, thanks Marcin.

	Ingo
