Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZBRTKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZBRTKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbZBRTJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:09:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39663 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbZBRTJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:09:58 -0500
Date: Wed, 18 Feb 2009 20:09:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: davej@codemonkey.org.uk, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Change link order of x86 cpufreq modules
Message-ID: <20090218190943.GF26802@elte.hu>
References: <20090218182822.GA19902@srcf.ucam.org> <20090218183137.GD26802@elte.hu> <20090218183641.GA20203@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218183641.GA20203@srcf.ucam.org>
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


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Wed, Feb 18, 2009 at 07:31:37PM +0100, Ingo Molnar wrote:
> 
> > Nice fix! Where does this information come from? Distro module 
> > ordering magic? It's rather non-trivial.
> 
> Pretty much. p4-clockmod is never the preferred option because 
> it does no voltage scaling. speedstep-centrino is now almost 
> entirely functionally replaced with acpi-cpufreq. The 
> powernow-k8 issue was a personal communication from davej.

I'm wondering whether that priority order should/could be 
expressed in the module space too - so that distros wouldnt have 
to replicate this. This is really a piece of information the 
kernel is best at maintaining.

> > (small style nit: the first line in the Makefile is overlong.)
> 
> Seems to be 79 characters?

[ oops, my eye-guesstimator is failing me :) ]

	Ingo
