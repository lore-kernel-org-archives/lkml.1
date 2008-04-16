Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbYDPNAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbYDPNAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763865AbYDPM7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 08:59:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58888 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763700AbYDPM7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 08:59:46 -0400
Date: Wed, 16 Apr 2008 14:59:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 vDSO: compile with -g
Message-ID: <20080416125931.GE6304@elte.hu>
References: <20080414191930.B2D9F26FA5F@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414191930.B2D9F26FA5F@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> The 64-bit vDSO's sources are compiled with -g0 for no good reason. 
> Using -g when enabled lets their separate debug files be used at 
> runtime via build ID matching, same as we can see 32-bit vDSO's 
> assembly sources.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>

thanks Roland, applied.

	Ingo
