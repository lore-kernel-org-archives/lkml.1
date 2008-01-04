Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbYADIlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbYADIlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 03:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYADIlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 03:41:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60937 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbYADIlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 03:41:09 -0500
Date: Fri, 4 Jan 2008 09:40:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [18/20] x86: Don't disable TSC in any C states on AMD
	Fam10h
Message-ID: <20080104084043.GA27278@elte.hu>
References: <20080103149.088038000@suse.de> <20080103005014.2F86314D40@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103005014.2F86314D40@wotan.suse.de>
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

> The ACPI code currently disables TSC use in any C2 and C3 states. But 
> the AMD Fam10h BKDG documents that the TSC will never stop in any C 
> states when the CONSTANT_TSC bit is set. Make this disabling 
> conditional on CONSTANT_TSC not set on AMD.
> 
> I actually think this is true on Intel too for C2 states on CPUs with 
> p-state invariant TSC, but this needs further discussions with Len to 
> really confirm :-)
> 
> So far it is only enabled on AMD.

thanks Andi - i've picked this up for x86.git, to get it tested. Len, 
what do you think? If/when you pick it up into the ACPI tree i'll drop 
it from x86.git.

	Ingo
