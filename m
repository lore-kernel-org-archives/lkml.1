Return-Path: <linux-kernel-owner+w=401wt.eu-S932930AbZHUWia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbZHUWia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 18:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbZHUWi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 18:38:29 -0400
Received: from www.tglx.de ([62.245.132.106]:42687 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbZHUWi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 18:38:28 -0400
Date: Sat, 22 Aug 2009 00:36:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: Re: [RFC patch 02/32] x86: Add probe_roms to platform_setup
In-Reply-To: <4A8F1E4D.9080409@goop.org>
Message-ID: <alpine.LFD.2.00.0908220034110.1769@localhost.localdomain>
References: <20090821205008.518392436@linutronix.de> <20090821205601.878468441@linutronix.de> <4A8F1E4D.9080409@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009, Jeremy Fitzhardinge wrote:

> On 08/21/09 14:29, Thomas Gleixner wrote:
> [argh attachments]

No. :)

Content-Disposition: inline;
    filename=x86-add-probe-roms-to-platform-setup.patch

> > probe_roms is only used on 32bit. Add it to the platform_setup code
> > and remove the #ifdefs.
> >
> > Default initializer is platform_setup_noop() which is overridden in
> > the 32bit boot code.
> >
> >   
> 
> I realize you're aiming to make this transform have no functional
> side-effects, but is there a good reason why probe_roms *couldn't* be
> done in 64-bit?  It seems to me that its useful for coverage
> completeness to have the 32 and 64 bit do the same thing even if its
> sometimes redundant.

Yes. I aimed for functional equivilance in the first place and this is
a RFC so any improvements are welcome.

Thanks,

	tglx
