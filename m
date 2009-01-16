Return-Path: <linux-kernel-owner+w=401wt.eu-S938057AbZAPWld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938057AbZAPWld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764312AbZAPWlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:41:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55693 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288AbZAPWlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:41:19 -0500
Date: Fri, 16 Jan 2009 23:41:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Define ARCH_WANT_FRAME_POINTERS
Message-ID: <20090116224114.GF3899@elte.hu>
References: <4970D0A7.90005@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4970D0A7.90005@suse.com>
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


* Jeff Mahoney <jeffm@suse.com> wrote:

>  Commit da4276b8299a6544dc41ac2485d3ffca5811b3fb changed a dependency
>  for FRAME_POINTER from X86 to ARCH_WANT_FRAME_POINTERS, but didn't
>  actually define it.
> 
>  This patch adds the definition for ARCH_WANT_FRAME_POINTERS. Without it,
>  FRAME_POINTER can't be enabled on x86.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
> 
>  lib/Kconfig.debug |    6 ++++++
>  1 file changed, 6 insertions(+)

Yes - doh! :-)

Applied to tip/x86/urgent, thanks Jeff!

	Ingo
