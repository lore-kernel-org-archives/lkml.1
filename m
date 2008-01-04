Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYADIiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYADIiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 03:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYADIis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 03:38:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45589 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbYADIir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 03:38:47 -0500
Date: Fri, 4 Jan 2008 09:38:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [16/20] x86: Allow TSC clock source on AMD Fam10h and
	some cleanup
Message-ID: <20080104083818.GA26921@elte.hu>
References: <20080103149.088038000@suse.de> <20080103005012.124DE14D40@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103005012.124DE14D40@wotan.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> After a lot of discussions with AMD it turns out that TSC on Fam10h 
> CPUs is synchronized when the CONSTANT_TSC cpuid bit is set. Or rather 
> that if there are ever systems where that is not true it would be 
> their BIOS' task to disable the bit.
> 
> So finally use TSC gettimeofday on Fam10h by default.

thanks, applied.

	Ingo
