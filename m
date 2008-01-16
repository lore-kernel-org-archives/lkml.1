Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbYAPHbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbYAPHbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 02:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYAPHbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 02:31:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39491 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbYAPHbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 02:31:04 -0500
Date: Wed, 16 Jan 2008 08:29:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: venkatesh.pallipadi@intel.com
Cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
	fixes
Message-ID: <20080116072923.GD30950@elte.hu>
References: <20080116023955.597433000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116023955.597433000@intel.com>
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


* venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com> wrote:

> Some incremental changes and bug fixes for PAT patchset. The changes 
> are from the feedback we received earlier. There are few more pending 
> changes that will follow soon.

thanks, applied them to x86.git.

Note that PAT is still hardcoded to disabled in arch/x86/mm/pat.c:

  int __read_mostly pat_disabled = 1;

because one of my testsystems failed during bootup. I'll re-check 
whether these fixes resolve that, and if it passes then we could enable 
PAT.

	Ingo
