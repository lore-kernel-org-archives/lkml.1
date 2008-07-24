Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbYGXFGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbYGXFGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 01:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYGXFG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 01:06:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59050 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbYGXFG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 01:06:29 -0400
Date: Thu, 24 Jul 2008 07:03:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, suresh.b.siddha@intel.com,
       hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com,
       andi@firstfloor.org, ebiederm@xmission.com, jbarnes@virtuousgeek.org,
       steiner@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and
	x2apic support
Message-ID: <20080724050300.GB25161@elte.hu>
References: <20080710181634.764954000@linux-os.sc.intel.com> <20080710195320.GA23322@elte.hu> <20080722134909.2cbf719b.akpm@linux-foundation.org> <48864A7F.3050908@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48864A7F.3050908@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Andrew Morton wrote:
> > On Thu, 10 Jul 2008 21:53:20 +0200
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> >> For review and testing purposes i've created a new topic branch for 
> >> this: tip/x86/x2apic and have picked up your patches into it.
> > 
> > This has today turned up in linux-next and I'm having to rework 2.6.27
> > patches to compensate for it.
> > 
> > Which means that I now need to wait until this work goes into mainline
> > before I can merge those patches or I need to undo those fixes, route
> > around Suresh's changes and then force you to fix the resulting damage.
> > 
> > What's the score here?  Is this stuff going into 2.6.27?
> 
> Hi Andrew,
> 
> Jack is out at OLS this week, but yes I believe we're trying to push 
> this into 6.2.27 as that is what the distro's will be basing their 
> distributions on when the new system sees the light of day.

Note that this is the generic x2apic work from Intel, not the SGI/UV 
specific x2apic stuff. The SGI-specific code is upstream already. (and 
as i understand it was based on an earlier version of the Intel code)

The Intel x2apic code was submitted before the merge window but was 
indeed pushed to linux-next during the window because that's when its 
integration became fully ready. We'd rather not hold the whole merge 
window and linux-next hostage with not fully ready stuff :-)

	Ingo
