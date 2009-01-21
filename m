Return-Path: <linux-kernel-owner+w=401wt.eu-S1763421AbZAUBC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763421AbZAUBC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 20:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757312AbZAUBCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 20:02:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:53532 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306AbZAUBCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 20:02:18 -0500
Subject: Re: [BUG] kernel BUG at arch/x86/kernel/tlb_32.c:130!
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <49766FF0.9040401@cn.fujitsu.com>
References: <49756F44.6040801@cn.fujitsu.com>
	 <20090120075440.GA29426@elte.hu> <20090120081759.GA30394@elte.hu>
	 <49758937.5070300@cn.fujitsu.com> <20090120082946.GC31473@elte.hu>
	 <49766FF0.9040401@cn.fujitsu.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 06:31:42 +0530
Message-Id: <1232499702.3123.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-21 at 08:44 +0800, Li Zefan wrote:
> >>> okay, a testsystem of mine just triggered this crash too.
> >>>
> >>> Li Zefan, Jaswinder, does the patch below fix it for you?
> >>>
> >> I'll test it, but I have to run for several hours to confirm it, since 
> >> the bug is not easy to trigger. :)
> > 
> > yes. It triggered on an old 32-bit dual-socket HyperThreading system for 
> > me and that is because HyperThreading is very good at triggering narrow 
> > SMP races. (which this one certainly is)
> > 
> > (I'd expect Nehalem to trigger this TLB flushing race more easily too, 
> > where HyperThreading made a comeback.)
> > 
> 
> Nothing bad happaned in the last 16+ hours. :)
> 
> Tested-by: Li Zefan <lizf@cn.fujitsu.com>
> 

And my HT machine is also happy with this patch :-)

--
JSR

