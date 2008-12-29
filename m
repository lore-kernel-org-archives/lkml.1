Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYL2MMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYL2MMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbYL2MMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:12:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47672 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbYL2MM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:12:29 -0500
Date: Mon, 29 Dec 2008 13:12:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       mj@ucw.cz
Subject: Re: [PATCH] move arch/x86/pci/pci.h to
	arch/x86/include/asm/pci_x86.h
Message-ID: <20081229121218.GB9628@elte.hu>
References: <1230382948.3373.1.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230382948.3373.1.camel@jaswinder.satnam>
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


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> Impact: cleanup, arch/x86/pci/pci.h -> arch/x86/include/asm/pci_x86.h
> 
> Tested on: X86_32_UP, X86_32_SMP and X86_64_SMP
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/include/asm/pci_x86.h     |  165 ++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/mmconf-fam10h_64.c |    3 +-
>  arch/x86/kernel/reboot.c           |    3 +-
>  arch/x86/pci/acpi.c                |    2 +-
>  arch/x86/pci/amd_bus.c             |    2 +-
>  arch/x86/pci/common.c              |    3 +-
>  arch/x86/pci/direct.c              |    2 +-
>  arch/x86/pci/early.c               |    2 +-
>  arch/x86/pci/fixup.c               |    3 +-
>  arch/x86/pci/i386.c                |    2 +-
>  arch/x86/pci/init.c                |    2 +-
>  arch/x86/pci/irq.c                 |    3 +-
>  arch/x86/pci/legacy.c              |    2 +-
>  arch/x86/pci/mmconfig-shared.c     |    3 +-
>  arch/x86/pci/mmconfig_32.c         |    2 +-
>  arch/x86/pci/mmconfig_64.c         |    3 +-
>  arch/x86/pci/numaq_32.c            |    2 +-
>  arch/x86/pci/olpc.c                |    2 +-
>  arch/x86/pci/pcbios.c              |    5 +-
>  arch/x86/pci/pci.h                 |  162 -----------------------------------
>  arch/x86/pci/visws.c               |    3 +-
>  21 files changed, 185 insertions(+), 191 deletions(-)
>  create mode 100644 arch/x86/include/asm/pci_x86.h
>  delete mode 100644 arch/x86/pci/pci.h

applied to tip/x86/cleanups (with an expanded changelog), thanks!

	Ingo
