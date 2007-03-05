Return-Path: <linux-kernel-owner+w=401wt.eu-S932364AbXCENrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbXCENrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933017AbXCENrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:47:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47785 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364AbXCENrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:47:07 -0500
Date: Mon, 5 Mar 2007 14:38:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>, Andi Kleen <ak@suse.de>,
       virtualization <virtualization@lists.osdl.org>
Subject: Re: [patch] paravirt: VDSO page is essential
Message-ID: <20070305133828.GA29200@elte.hu>
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173101297.26165.39.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> -#ifdef CONFIG_PARAVIRT
> +#if defined(CONFIG_COMPAT_VDSO) && defined(CONFIG_RESERVE_TOP)

NACK - my patch is quite a bit simpler and yours only increases the
#ifdef jungle. If there's any complication of the VDSO coming from some
other hypervisor support patch then I will judge that in full context, 
when it's submitted. Meanwhile, my patch is a must-have for v2.6.21.

	Ingo
