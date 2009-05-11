Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbZEKPTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbZEKPTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbZEKPSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:18:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43310 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbZEKPSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:18:47 -0400
Date: Mon, 11 May 2009 17:18:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM][retry 1] Add support for Pause Filtering to AMD
	SVM
Message-ID: <20090511151823.GC9492@elte.hu>
References: <200905050909.58583.mark.langsdorf@amd.com> <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com> <4A02FECC.6060609@redhat.com> <20090511141503.GC6175@elte.hu> <4A083539.407@redhat.com> <20090511143320.GE6175@elte.hu> <4A083B69.6010702@redhat.com> <20090511145903.GB737@elte.hu> <4A08405E.3070709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A08405E.3070709@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

>> I.e. the 3000 cycles value itself could be eliminated as well. 
>> (with just a common-sense max of say 100,000 cycles enforced)
>
> Yeah, though that has a much smaller effect as it's only 
> responsible for a few microseconds of spinning.

3000 cycles would be 1-2 usecs. Isnt the VM exit+entry cost still in 
that range?

	Ingo
