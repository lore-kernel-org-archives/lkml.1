Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYD2KVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYD2KVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbYD2KVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:21:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44454 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbYD2KVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:21:22 -0400
Date: Tue, 29 Apr 2008 12:21:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] ARCH: Fix 32-bit x86 MSI-X allocation leakage
Message-ID: <20080429102107.GH23198@elte.hu>
References: <20080426005850.7098.77479.stgit@scrappy.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426005850.7098.77479.stgit@scrappy.jf.intel.com>
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


* PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com> wrote:

> This bug was introduced in the 2.6.24 i386/x86_64 tree merge, [...]

that's wrong, that code was there in v2.6.23 too - and it wasnt touched 
in the unification. Why do you think it was introduced in the 
i386/x86_64 tree merge?

... the fix is right though, thanks!
 
	Ingo
