Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbYJ0LCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbYJ0LCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYJ0LCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:02:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47178 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbYJ0LCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:02:23 -0400
Date: Mon, 27 Oct 2008 12:02:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 0/4] V3 Hypervisor detection and tsc_reliable feature
	definition
Message-ID: <20081027110218.GD13641@elte.hu>
References: <1224894087.28224.69.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224894087.28224.69.camel@alok-dev1>
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


* Alok Kataria <akataria@vmware.com> wrote:

> Hi,
> 
> These patches define a framework for hypervisor detection and 
> setting of hypervisor feature bits. We define a 
> X86_FEATURE_TSC_RELIABLE bit which is a synthetic bit. This is set 
> when running under VMware. This feature bit is used to skip TSC 
> checks which can fail on virtualization platform due to timing 
> differences when running on virtual cpus.

okay, this looks a lot better structurally - the DMI angle and the 
synthetic CPU flag, and the clocksource smarts are all a clean 
approach. Peter, any objections?

	Ingo
