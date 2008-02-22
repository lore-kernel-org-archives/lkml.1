Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbYBVJpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbYBVJpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYBVJp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:45:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53913 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbYBVJp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:45:27 -0500
Date: Fri, 22 Feb 2008 10:45:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: don't print a warning when MTRR are blank and
	running in KVM
Message-ID: <20080222094513.GA6269@elte.hu>
References: <1203605414-4958-1-git-send-email-joerg.roedel@amd.com> <20080221203748.GA9031@elte.hu> <47BDFBDE.5040102@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BDFBDE.5040102@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

>> I'm not sure how we could detect pure Qemu instances - perhaps it 
>> should define some special MSR or something?
>
> Perhaps they should fix the Qemu BIOS to actually simulate working 
> MSRs; if nothing else, they should set up the default MTRR to be 
> cachable.

btw., should KVM do the same?

	Ingo
