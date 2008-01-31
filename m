Return-Path: <linux-kernel-owner+w=401wt.eu-S933060AbYAaKrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060AbYAaKrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764361AbYAaKrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:47:06 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53848 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757659AbYAaKrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:47:04 -0500
Date: Thu, 31 Jan 2008 12:47:38 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-ia64@vger.kernel.org, sparclinux@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Message-ID: <20080131104738.GA30750@cs181133002.pp.htv.fi>
References: <200801301414.m0UEEgCC006371@hera.kernel.org> <Pine.LNX.4.64.0801301622460.11859@vixen.sonytel.be> <47A09F8A.3000309@sgi.com> <20080130161036.GA12293@elte.hu> <1FE6DD409037234FAB833C420AA843EC757C72@orsmsx424.amr.corp.intel.com> <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <47A0CD4B.5040706@sgi.com> <1FE6DD409037234FAB833C420AA843EC757F12@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC757F12@orsmsx424.amr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 11:33:29AM -0800, Luck, Tony wrote:
> > I'm having trouble replicating this error.  With the latest linux-2.6.git
> > plus the patch I just sent, I get the following errors:
> >
> > drivers/input/mouse/psmouse-base.c:45: error: __param_proto causes a section type conflict
> > drivers/md/md.c:5881: error: __param_start_ro causes a section type conflict
> 
> Weird.  psmouse-base.c builds ok for me.  Perhaps there is a compiler
> version difference?  I'm running a rather old 3.4.6 that came with
> my RHEL 4.5 release.
>...

It depends on the compiler version.

And you were in the Cc of Ivan's patch that fixes it... [1]

> -Tony

cu
Adrian

[1] http://lkml.org/lkml/2007/12/27/29

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

