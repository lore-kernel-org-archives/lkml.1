Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYIWXPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYIWXPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 19:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYIWXO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 19:14:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37935 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbYIWXO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 19:14:56 -0400
Subject: Re: mmotm 2008-09-22-01-36 uploaded (memory_hotplug)
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, lethal@linux-sh.org
In-Reply-To: <20080923151748.7268cf16.akpm@linux-foundation.org>
References: <200809220838.m8M8cwC2031790@imap1.linux-foundation.org>
	 <20080922112918.c6ea4e05.randy.dunlap@oracle.com>
	 <20080922125731.0ee87e05.akpm@linux-foundation.org>
	 <1222207702.6491.10.camel@badari-desktop>
	 <20080923151748.7268cf16.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 16:14:52 -0700
Message-Id: <1222211692.6491.12.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-23 at 15:17 -0700, Andrew Morton wrote:
> On Tue, 23 Sep 2008 15:08:22 -0700
> Badari Pulavarty <pbadari@us.ibm.com> wrote:
> 
> > > > so it is defined in both mm/memory_hotplug.c and
> > > > arch/x86/mm/init_64.c when CONFIG_MEMORY_HOTREMOVE=y.
> > > > 
> > > 
> > > OK, thanks, it looks like people are changing things under our feet.
> > > 
> > > Badari, can you please check this fix against
> > > mm-cleanup-to-make-remove_memory-arch-neutral.patch?
> > > 
> > 
> > 
> > When I made the patch, only ppc64, ia64 and s390 had
> > memory_remove() support in mainline. I sent a patch against
> > x86 to add hotplug memory remove support. I guess you
> > merged Gary's patch and sh-arch patch.
> > 
> > I noticed that you cleaned up all these and added to -mm.
> > Do you want me to merge all these into a single patch and 
> > resend it (against -mm) ?
> 
> No, that's OK.
> 
> > (It will look exactly the same
> > anyway).
> 
> Does that mean you reviewed all the fixes I added?  We're sure that all
> the per-arch implementations of remove_memory() can be replaced by the
> generic one?

Yes. I just reviewed all these patches in mmtom 2008-09-23. 
They looked fine. There is no need for arch-specific ones.

Thanks,
Badari

