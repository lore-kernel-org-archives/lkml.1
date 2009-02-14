Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbZBNI0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbZBNI0h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 03:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZBNI03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 03:26:29 -0500
Received: from gw.goop.org ([64.81.55.164]:46924 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbZBNI03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 03:26:29 -0500
Message-ID: <49968032.3060107@goop.org>
Date: Sat, 14 Feb 2009 00:26:26 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] some core Xen updates
References: <49908591.5020406@goop.org>
In-Reply-To: <49908591.5020406@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Hi Ingo,
>
> Here's some core Xen changes: bug fixes, debuggability improvements 
> and cleanups.
> These are based on tip/x86/xen, but I've merged in tip/master to bring 
> it up to date
> before adding my changes.

Ping?

    J

>
> BTW, I killed off all the jsgf/* branches in xen.git, but I think 
> you've either
> already picked up all the push requests, or I'll resend anything missing.
>
> Thanks,
>     J
>
> The following changes since commit 
> a1c51abb06bf03bef6ff973e43cf20a0fa48384f:
>  Ingo Molnar (1):
>        Merge branch 'x86/urgent'
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen/core
>
> Ian Campbell (2):
>      Fix xen_flush_tlb_others
>      xen: record and display initiator of each multicall when debugging
>
> Jeremy Fitzhardinge (5):
>      Merge remote branch 'tip/master' into tip/fixups
>      xen: short-circuit tests for dom0
>      xen: degrade BUG to WARN when multicall fails
>      xen: do multicall callbacks with interrupts disabled
>      Merge branch 'tip/fixups' into xen/core
>
> arch/x86/include/asm/xen/hypervisor.h |   28 ++++++++++++++++++----------
> arch/x86/xen/mmu.c                    |    3 ---
> arch/x86/xen/multicalls.c             |   15 ++++++++++-----
> 3 files changed, 28 insertions(+), 18 deletions(-)
>
>
>

