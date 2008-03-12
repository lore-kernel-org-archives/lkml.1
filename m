Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYCLHEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYCLHEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 03:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYCLHEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 03:04:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbYCLHEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 03:04:33 -0400
Date: Wed, 12 Mar 2008 08:04:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mpparse_{32,64}.c merge questions
Message-ID: <20080312070419.GA18216@elte.hu>
References: <47CDB9D7.9030107@suse.de> <47CDBFD9.1050703@suse.de> <20080304213552.GD8944@elte.hu> <200803111328.43314.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803111328.43314.lenb@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> > we dont, but please do _not_ "redesign" anything during unification.
> > 
> > try to keep it simple and bisectable. Lots of small patches. Stupid
> > #ifdefs if need to be. Pick the 32-bit version or the 64-bit version 
> > of any approach, if it's obvious that the unified version will still 
> > work fine. Ask if in doubt.
> 
> I agree with Ingo on the "keep it simple" merge steps..
> 
> I can't resist mentioning, however, what I'd like to see long term.
> 
> I'd like to see mpparse.o depend on CONFIG_MPS=y
> I'd like to be able to build CONFIG_ACPI=y and CONFIG_MPS=n
> 
> Andy Grover prototyped splititing MPS from ACPI a while back, but it 
> never made it upstream.

sure and agreed. And this absolutely has to happen in a separate 
patchset. Unification is done best by not changing much and by delaying 
any difficult change to as late in the unification effort as possible. 
(thus any non-trivial change, if it breaks things and has to be 
reverted, wont pull another 100 "easy" changes with itself)

	Ingo
