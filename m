Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYGJKpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYGJKpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 06:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbYGJKpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 06:45:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56617 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbYGJKpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 06:45:03 -0400
Date: Thu, 10 Jul 2008 12:44:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86/pci: Broken build for X86_VISWS
Message-ID: <20080710104446.GA3131@elte.hu>
References: <20080710095757.GB5607@erda.amd.com> <20080710102305.GA20096@elte.hu> <20080710104216.GK7963@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710104216.GK7963@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 10.07.08 12:23:05, Ingo Molnar wrote:
> > well spotted. Does the patch below fix it for you?
> 
> Yes, it should. I send out a fix with the same change and it builds 
> well. But I did not realize that X86_VSMP was also affected.

i'm wondering why you werent hit by the generic-ipi build bug. Perhaps 
you had SMP disabled?

	Ingo
