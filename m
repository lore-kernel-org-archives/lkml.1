Return-Path: <linux-kernel-owner+w=401wt.eu-S1030574AbXBAH45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030574AbXBAH45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 02:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030570AbXBAH45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 02:56:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36648 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030574AbXBAH44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 02:56:56 -0500
Date: Thu, 1 Feb 2007 08:55:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH] KVM: Fix lockup on 32-bit intel hosts with nx disabled in the bios
Message-ID: <20070201075505.GA14378@elte.hu>
References: <20070131150017.020B9A0014@il.qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131150017.020B9A0014@il.qumranet.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> Intel hosts, without long mode, and with nx support disabled in the 
> bios have an efer that is readable but not writable.  This causes a 
> lockup on switch to guest mode (even though it should exit with reason 
> 34 according to the documentation).
> 
> Signed-off-by: Avi Kivity <avi@qumranet.com>

i think this is for v2.6.20. I have tested this ontop of -rc7.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
