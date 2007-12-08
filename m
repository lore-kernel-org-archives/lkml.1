Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbXLHJSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbXLHJSj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 04:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbXLHJS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 04:18:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47568 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943AbXLHJS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 04:18:26 -0500
Date: Sat, 8 Dec 2007 10:17:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: [git pull] x86/hrtimer/acpi fixes
Message-ID: <20071208091706.GB20516@elte.hu>
References: <20071207183633.GC26778@elte.hu> <1197053386.32023.13.camel@cmn3.stanford.edu> <20071207185920.GA3006@elte.hu> <1197055769.32023.22.camel@cmn3.stanford.edu> <1197056910.32023.25.camel@cmn3.stanford.edu> <20071207195958.GA12529@elte.hu> <1197076100.32023.67.camel@cmn3.stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197076100.32023.67.camel@cmn3.stanford.edu>
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


* Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:

> On Fri, 2007-12-07 at 20:59 +0100, Ingo Molnar wrote:
> > * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> > 
> > > > Nope, it doesn't still getting "delay" and "xrun" messages galore.
> > > 
> > > Attached: configuration and dmesg output booting with idle=poll, 
> > > reconfirmed that that makes the delay and xrun messages go away.
> > 
> > could you try the rolled up patch of various fixlets, ontop of 
> > current -git? (it might even apply to -rc4) It includes some more 
> > stuff beyond the ones in the pull request. (still being 
> > tested/reviewed)
> 
> I'll try but it will take me a while to figure git and do a package 
> build of it...

if you want to try a vanilla kernel package then pick up the kernel 
package from Fedora rawhide - this fixlet should show up there within a 
couple of days, Dave Jones is doing a really nice job of keeping up with 
latest -git. (and the Fedora kernel has hrtimers and dynticks enabled.)

	Ingo
