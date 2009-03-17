Return-Path: <linux-kernel-owner+w=401wt.eu-S1762980AbZCQJje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762980AbZCQJje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 05:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbZCQJjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 05:39:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57864 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbZCQJjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 05:39:25 -0400
Date: Tue, 17 Mar 2009 10:39:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       akataria@vmware.com
Subject: Re: [PATCH -tip] x86: move vmware to hypervisor
Message-ID: <20090317093919.GD6477@elte.hu>
References: <1237281581.7907.2.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237281581.7907.2.camel@ht.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Subject: [PATCH] x86: move vmware to hypervisor
> 
> Impact: cleanup
> 
> vmware is only required by hypervisor and having only two functions
> by moving these two functions to hypervisor we get rid of 2 vmware files
> 
> Added support for CONFIG_X86_HYPERVISOR
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/Kconfig                  |   12 ++++
>  arch/x86/include/asm/hypervisor.h |   34 ++++++++++-
>  arch/x86/include/asm/vmware.h     |   27 ---------
>  arch/x86/kernel/cpu/Makefile      |    2 +-
>  arch/x86/kernel/cpu/hypervisor.c  |   80 ++++++++++++++++++++-------
>  arch/x86/kernel/cpu/vmware.c      |  112 -------------------------------------
>  6 files changed, 104 insertions(+), 163 deletions(-)
>  delete mode 100644 arch/x86/include/asm/vmware.h
>  delete mode 100644 arch/x86/kernel/cpu/vmware.c

I dont really like this one. KVM is a hypervisor too, and so is 
Xen and lguest. VMware is one of the many types of a 
hypervisors.

	Ingo
