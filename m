Return-Path: <linux-kernel-owner+w=401wt.eu-S1751243AbZLRFPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243AbZLRFPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 00:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbZLRFPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 00:15:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40886 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbZLRFPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 00:15:15 -0500
Date: Fri, 18 Dec 2009 06:14:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [git pull request] ACPI and driver patches for 2.6.33.merge
Message-ID: <20091218051457.GB417@elte.hu>
References: <alpine.LFD.2.00.0912161453480.10371@localhost.localdomain>
 <86802c440912171728s27dd7108k85a0f1563660c95b@mail.gmail.com>
 <20091218022112.GA30333@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218022112.GA30333@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Shaohua Li <shaohua.li@intel.com> wrote:

> On Fri, Dec 18, 2009 at 09:28:50AM +0800, Yinghai Lu wrote:
> > On Wed, Dec 16, 2009 at 12:06 PM, Len Brown <lenb@kernel.org> wrote:
> > > Hi Linus,
> > >
> > > please pull from:
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> > >
> > ;..
> > >
> > > Shaohua Li (3):
> > > ? ? ?ACPI: Add a generic API for _OSC -v2
> > > ? ? ?ACPI: cleanup pci_root _OSC code.
> > > ? ? ?ACPI: Add platform-wide _OSC support.
> > 
> > it seems these three patches broke the _OSC on my intel new systems.
> > 
> > revert them fix the problem with AER and pciehp and etc
>
> can you give more details? I just cleaned up the _OSC code for AER and 
> pciehp, no function changes.

Famous last words ;-)

Yinghai, i suspect Shaohua needs the kind of info you'd need if you tried to 
fix it: acpidump, before/after debug boot log, a description of what goes bad, 
etc.

Thanks,

	Ingo
