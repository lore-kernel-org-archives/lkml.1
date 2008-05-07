Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYEGNhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYEGNhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 09:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYEGNgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 09:36:52 -0400
Received: from www.tglx.de ([62.245.132.106]:35986 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbYEGNgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 09:36:50 -0400
Date: Wed, 7 May 2008 15:36:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Sesterhenn <snakebyte@gmx.de>
cc: Ingo Molnar <mingo@elte.hu>, Frederik Deweerdt <deweerdt@free.fr>,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Oops with strace_test
In-Reply-To: <20080507103615.GC2340@alice>
Message-ID: <alpine.LFD.1.10.0805071534580.3318@apollo.tec.linutronix.de>
References: <20080430121202.GD18314@alice> <20080505100008.GA2354@alice> <20080505180053.GB5576@slug> <20080506121005.GJ32591@elte.hu> <20080507103615.GC2340@alice>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Eric Sesterhenn wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Frederik Deweerdt <deweerdt@free.fr> wrote:
> > 
> > > Hi Eric,
> > > 
> > > This appears to be caused by init_fpu() missing from the 
> > > restore_sigcontext->restore_i387->restore_fpu_checking code path.
> > > 
> > > I believe that moving the init_fpu() call from math_state_restore to 
> > > restore_fpu_checking should fix the problem?
> 
> sadly the patch does not work for me :( I still get the oopses. I am
> running this on a 32 Bit CPU, so arch/x86/kernel/traps_64.c doesnt get
> compiled. I tried removing the same part from traps_32.c but then
> the kernel oopses before netconsole is active.

I run that &$#@! intuitive test for an hour know with no effect. Can
you please provide your .config file ?

Thanks,
	tglx
