Return-Path: <linux-kernel-owner+w=401wt.eu-S932518AbZDAPBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbZDAPBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758525AbZDAPBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:01:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48069 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761423AbZDAPBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:01:18 -0400
Date: Wed, 1 Apr 2009 17:01:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       xemul@openvz.org, yhlu.kernel@gmail.com
Subject: Re: [patch 6/6] x86: irqinit - merge irqinit_32/64.c into irqinit.c
Message-ID: <20090401150101.GC6196@elte.hu>
References: <20090329201545.470255691@openvz.org> <20090329202208.439338795@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329202208.439338795@openvz.org>
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


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> So the files are merged there is still #include's
> mess -- need serious cleanup.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/kernel/Makefile     |    2 
>  arch/x86/kernel/irqinit.c    |  249 +++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/irqinit_32.c |  246 ------------------------------------------
>  arch/x86/kernel/irqinit_64.c |  249 -------------------------------------------
>  4 files changed, 250 insertions(+), 496 deletions(-)

ok, this looks pretty well done.

If you could do the x86_quirk cleanup on top of this i guess we 
could try it. (no need to redo the unification with the quirk thing, 
that will break this patch.)

	Ingo
