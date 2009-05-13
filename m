Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbZEMNan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbZEMNan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZEMNae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:30:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43015 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbZEMNad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:30:33 -0400
Date: Wed, 13 May 2009 15:30:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
Message-ID: <20090513133021.GA7277@elte.hu>
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242170864-13560-1-git-send-email-jeremy@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> Hi Ingo,
> 
> This series of patches makes /proc/mtrr fully functional under Xen.
> 
> Thanks,
> 	J
> 
> The following changes since commit ce791368bb4a53d05e78e1588bac0aacde8db84c:
>   Jeremy Fitzhardinge (1):
>         xen/i386: make sure initial VGA/ISA mappings are not overridden
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git for-ingo/xen/dom0/mtrr
> 
> Jeremy Fitzhardinge (1):
>       xen: set cpu_callout_mask to make mtrr work
> 
> Mark McLoughlin (5):
>       xen mtrr: Use specific cpu_has_foo macros instead of generic cpu_has()
>       xen mtrr: Use generic_validate_add_page()
>       xen mtrr: Implement xen_get_free_region()
>       xen mtrr: Add xen_{get,set}_mtrr() implementations
>       xen mtrr: Kill some unnecessary includes
> 
>  arch/x86/kernel/cpu/mtrr/mtrr.h |    2 +
>  arch/x86/kernel/cpu/mtrr/xen.c  |   99 ++++++++++++++++++++++++++++++++-------
>  arch/x86/xen/smp.c              |    2 +
>  3 files changed, 86 insertions(+), 17 deletions(-)

i never got a reply to my question for your previous submission:

  http://lkml.indiana.edu/hypermail/linux/kernel/0905.1/00152.html

	Ingo
