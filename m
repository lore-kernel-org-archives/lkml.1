Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYKTIDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYKTIDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 03:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbYKTIDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 03:03:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54193 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbYKTID3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:03:29 -0500
Date: Thu, 20 Nov 2008 09:03:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Richard A. Holden III" <aciddeath@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Fix arch/x86/kernel/genx2apic_uv_x.c build warning
	when !CONFIG_HOTPLUG_CPU
Message-ID: <20081120080316.GB21785@elte.hu>
References: <1227135915-32628-1-git-send-email-aciddeath@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227135915-32628-1-git-send-email-aciddeath@gmail.com>
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


* Richard A. Holden III <aciddeath@gmail.com> wrote:

> Fix
> arch/x86/kernel/genx2apic_uv_x.c:403: warning: 'uv_heartbeat_disable' defined but not used
> 
> the function is only used when CONFIG_HOTPLUG_CPU is defined.

applied to tip/x86/uv, thanks Richard!

	Ingo
