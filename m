Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbZDMUgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbZDMUgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 16:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZDMUgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 16:36:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35667 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbZDMUgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 16:36:24 -0400
Date: Mon, 13 Apr 2009 22:35:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Xen bugfixes for -rc1
Message-ID: <20090413203518.GC19972@elte.hu>
References: <49E385FE.8050902@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E385FE.8050902@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Linus,
>
> Please pull this set of Xen bugfixes/cleanups for -rc[12].
>
> Thanks,
>    J
>
> The following changes since commit 577c9c456f0e1371cbade38eaf91ae8e8a308555:
>  Linus Torvalds (1):
>        Linux 2.6.30-rc1
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git for-rc1/xen/core

I've pulled it into x86/urgent as well, thanks.

This is a strict subset of the Xen tree i sent to Linus to earlier, 
right?

The two places where there seems to have been some rebasing 
complexity is arch/x86/include/asm/required-features.h and 
arch/x86/xen/mmu.c.

Those bits are tested now so while i have not tested this specific 
rebased/narrowed variant yet, Linus please feel free to pull it:

  Acked-by: Ingo Molnar <mingo@elte.hu>

as these fixes have been delayed enough already. Or if not, i'll 
send these bits tomorrow via x86/urgent, after testing.

	Ingo
