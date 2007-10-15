Return-Path: <linux-kernel-owner+w=401wt.eu-S1763413AbXJOJvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763413AbXJOJvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758981AbXJOJvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:51:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57982 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757848AbXJOJvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:51:45 -0400
Date: Mon, 15 Oct 2007 11:51:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND 2][PATCH 4/4] Modify KVM to update guest time
	accounting.
Message-ID: <20071015095125.GB28367@elte.hu>
References: <46E550EF.5080209@bull.net> <20071015093800.GA22818@elte.hu> <47133732.2090809@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47133732.2090809@qumranet.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> This bit can go; for the external module I can add it back in 
> external-module-compat.h.  No need to pollute mainline with backward 
> compatibility stuff.

hm:

static inline void kvm_guest_enter(void)
{
        current->flags |= PF_VCPU;
}

static inline void kvm_guest_exit(void)
{
}

shouldnt PF_VCPU be cleared in kvm_guest_exit()?

	Ingo
