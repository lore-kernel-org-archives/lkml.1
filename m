Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbZD2M4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbZD2M4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZD2M4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:56:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41544 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbZD2M4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:56:11 -0400
Date: Wed, 29 Apr 2009 14:55:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Robert Richter <robert.richter@amd.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/29] x86/perfcounters: rework
	pmc_amd_save_disable_all() and pmc_amd_restore_all()
Message-ID: <20090429125556.GA31500@elte.hu>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com> <1241002046-8832-5-git-send-email-robert.richter@amd.com> <1241003260.8021.236.camel@laptop> <20090429111159.GJ2373@elte.hu> <18936.18732.35199.647196@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18936.18732.35199.647196@cargo.ozlabs.ibm.com>
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



* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar wrote:
> 
> > Could we remove the disable-all facility altogether and make the 
> > core code NMI-safe? The current approach wont scale on CPUs that 
> > dont have global-disable features.
> > 
> > disable-all was arguably a hack i introduced and which spread 
> > too far. Can you see a conceptual need for it?
> 
> If you're talking about hw_perf_save_disable / hw_perf_restore, 
> please don't get rid of those.  I use them to batch up counter 
> enable/disable operations so I only have to compute the PMU config 
> once for each batch rather than every time an individual counter 
> is enabled or disabled.

ok, sure.

	Ingo
