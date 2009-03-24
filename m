Return-Path: <linux-kernel-owner+w=401wt.eu-S1752340AbZCXUtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbZCXUtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbZCXUst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:48:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51623 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbZCXUss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:48:48 -0400
Date: Tue, 24 Mar 2009 16:40:28 -0400
From: Kyle McMartin <kyle@redhat.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "'Ingo Molnar'" <mingo@elte.hu>, "'Andrew Lutomirski'" <amluto@gmail.com>,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Jesse Barnes'" <jbarnes@virtuousgeek.org>,
       "'Kyle McMartin'" <kyle@redhat.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'Yinghai Lu'" <yinghai@kernel.org>,
       "Woodhouse, David" <david.woodhouse@intel.com>,
       "'Mark Gross'" <mgross@linux.intel.com>,
       "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu) enabled
Message-ID: <20090324204028.GE11771@kibblesnbits.boston.devel.redhat.com>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com> <20090324203259.GC26930@elte.hu> <A6AD88C3F2289247BE726C37303E1EB8A04DB530@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8A04DB530@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 01:36:46PM -0700, Yu, Fenghua wrote:
> >
> >(Cc:s added)
> >
> >* Andrew Lutomirski <amluto@gmail.com> wrote:
> >
> >> On vanilla 2.6.29 (on Ubuntu 8.10), on a Lenovo x200s, my system
> >> is completely hosed on resume.  It appears that even hard disk IO
> >> didn't work (trying to do *anything* including getting a dmesg
> >> trace just spewed sda io errors to the console).  Hence no trace.
> >> I did an alt-sysrq-b and the screen went blank and the machine
> >> just started beeping at me.
> >>
> >> Resume works much better with intel_iommu=off.  (I remember seeing
> >> a patch go by that purported to fix resume with IOMMU enabled, but
> >> it didn't work for me.)
> >>
> >> I'd be happy to try to make a better bug report if anyone has any
> >> bright ideas.
> >
> >i have a Lenovo T500 that does not even boot with with DMAR enabled
> >in the BIOS (it's default-off), i get this panic in early bootup:
> >
> >    DMAR hardware is malfunctioning
> >
> >So i dont get to test suspend/resume ;-)
> >
> Current kernel doesn't have iommu suspend/resume support yet. I'll send out suspend/resume patches today or tomorrow. Hope that will help.
> 

Heh, awesome, someone could have brought this, uhm, subtle, weakness when
things were getting defaulted on...

regards, Kyle
