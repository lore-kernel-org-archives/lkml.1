Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbYA3St7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbYA3St7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYA3Stt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:49:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46215 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbYA3Str (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:49:47 -0500
Date: Wed, 30 Jan 2008 19:49:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mike Travis <travis@sgi.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-ia64@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Message-ID: <20080130184920.GA32212@elte.hu>
References: <200801301414.m0UEEgCC006371@hera.kernel.org> <Pine.LNX.4.64.0801301622460.11859@vixen.sonytel.be> <47A09F8A.3000309@sgi.com> <20080130161036.GA12293@elte.hu> <1FE6DD409037234FAB833C420AA843EC757C72@orsmsx424.amr.corp.intel.com> <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com>
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


* Luck, Tony <tony.luck@intel.com> wrote:

> > Could you check the patch below? With this applied to latest -git, 
> > ia64 buils fine for me in a cross-compiling environment. (but i dont 
> > know whether it boots ...)
> 
> Uni-processor build still fails with this patch (config is 
> arch/ia64/configs/tiger_defconfig with CONFIG_SMP switched from =y to 
> =n).

could you try the full patchset that Travis has just sent and which i've 
put into x86.git, you can pull it from:

    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

it's a fixes only tree, ontop of Linus-very-latest. Head 4b9e425c25f84. 
[pull from ssh://master.kernel.org if it's not on git.kernel.org yet, 
uploaded it this very minute.]

	Ingo
