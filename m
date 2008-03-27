Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbYC0Ilv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbYC0Ilv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbYC0Ilo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:41:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35520 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbYC0Iln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:41:43 -0400
Date: Thu, 27 Mar 2008 09:41:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [RFC] x86: bitops asm constraint fixes
Message-ID: <20080327084130.GG15626@elte.hu>
References: <47EB56E0020000780004917E@public.id2-vpn.continvity.gns.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EB56E0020000780004917E@public.id2-vpn.continvity.gns.novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> Please revert it for the time being, I've got a better version (i.e. 
> without extra dead code being generated) that I intended to submit 
> once I know whether the other issues pointed out in the description on 
> the original patch also should be adjusted. Of course, that could also 
> be done incrementally, but I would think overhauling the whole file at 
> once wouldn't be a bad thing...

since it appears to cause no problems in x86.git (it passed a lot of 
testing already) i'd prefer to keep it (so that we can see any other 
side-effects of touching this code) - could you send your improvements 
as a delta against x86.git/latest? [or is there any outright bug caused 
by your changes that necessiates a revert?]

	Ingo
