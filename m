Return-Path: <linux-kernel-owner+w=401wt.eu-S934572AbYAaUia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934572AbYAaUia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 15:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933934AbYAaUhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 15:37:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57079 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933340AbYAaUhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 15:37:32 -0500
Date: Thu, 31 Jan 2008 21:37:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 04 of 11] x86: fix early_ioremap pagetable ops
Message-ID: <20080131203713.GA24278@elte.hu>
References: <de52cce203cd6edeed0d.1201296193@localhost> <1201806096.20036.43.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201806096.20036.43.camel@cthulhu.hellion.org.uk>
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


* Ian Campbell <ijc@hellion.org.uk> wrote:

> Some important parts of f6df72e71eba621b2f5c49b3a763116fac748f6e got 
> dropped along the way, reintroduce them.

thanks, applied. AFAICS it should only affect paravirt, not the native 
kernel, right?

	Ingo
