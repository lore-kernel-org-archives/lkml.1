Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYAYLMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYAYLMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 06:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYAYLMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 06:12:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47406 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbYAYLMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 06:12:30 -0500
Date: Fri, 25 Jan 2008 12:12:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v2
Message-ID: <20080125111219.GB20026@elte.hu>
References: <47993F1A.5070408@goop.org> <4799400C.1060102@zytor.com> <200801241947.55223.yinghai.lu@sun.com> <4799930B.40006@goop.org> <86802c440801250013p1a35b126l30fb7479b110e97d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440801250013p1a35b126l30fb7479b110e97d@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> is_cpu(INTEL) already make sure we have mtrr_if got assigned and 
> cpu_has_mtrr.
> 
> may need to fix qemu instead...

no ...

lets not do non-sensical trimming of RAM, ok? Emit a warning but never 
trim all of RAM and make the system unbootable. Trimmed RAM is something 
that users can pester board/BIOS vendors with. Non-booting kernels is 
something _we_ get pestered with ;-)

	Ingo
