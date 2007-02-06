Return-Path: <linux-kernel-owner+w=401wt.eu-S965165AbXBFSJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965165AbXBFSJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964784AbXBFSJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:09:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43886 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965165AbXBFSJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:09:54 -0500
Date: Tue, 6 Feb 2007 10:09:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: vgoyal@in.ibm.com
Cc: Andi Kleen <ak@suse.de>, Alon Bar-Lev <alon.barlev@gmail.com>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20 -- Loads of section mismatches
Message-Id: <20070206100935.08fee883.akpm@linux-foundation.org>
In-Reply-To: <20070206102754.GC17314@in.ibm.com>
References: <a44ae5cd0702041402g14051b58qfeb270a72123e22e@mail.gmail.com>
	<9e0cf0bf0702041406n50bd5639l66b62647d9c4795e@mail.gmail.com>
	<20070205064029.GA23996@in.ibm.com>
	<p73sldknali.fsf@bingen.suse.de>
	<20070206102754.GC17314@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007 15:57:54 +0530 Vivek Goyal <vgoyal@in.ibm.com> wrote:

> On Mon, Feb 05, 2007 at 11:48:57AM +0100, Andi Kleen wrote:
> > Vivek Goyal <vgoyal@in.ibm.com> writes:
> > > 
> > > http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/x86_64-mm-move-startup_32-in-texthead-section.patch
> > > 
> > > http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/x86_64-mm-break-init-in-two-parts-to-avoid-modpost-warnings.patch
> > 
> > The two part init / head.S patch was considered too intrusive late
> > in the game.
> > Near all of the other section patches should have made it in though.
> >
> 
> Yes all others have gone in. I found one more which is present in rc-mm2, but
> can't see it in rc6-mm3.
> 
> http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm2/broken-out/i386-modpost-apic-related-warning-fixes.patch
> 
> Andrew seems to have dropped it. Not sure why.

I commented it out in the series file because of clashes with git-acpi. 
I'll bring it back (somehow) once Andi and Len have sorted things out.
