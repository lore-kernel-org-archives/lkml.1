Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbYEVT6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbYEVT6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbYEVT6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:58:35 -0400
Received: from www.tglx.de ([62.245.132.106]:60652 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbYEVT6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:58:34 -0400
Date: Thu, 22 May 2008 21:58:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Glauber Costa <gcosta@redhat.com>,
       Miquel van Smoorenburg <miquels@cistron.nl>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       andi-suse@firstfloor.org
Subject: Re: 2.6.26: x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY ?
In-Reply-To: <20080522084736.GC31727@one.firstfloor.org>
Message-ID: <alpine.LFD.1.10.0805222157300.3295@apollo.tec.linutronix.de>
References: <20080521113028.GA24632@xs4all.net> <48341A57.1030505@redhat.com> <20080522084736.GC31727@one.firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Andi Kleen wrote:
> On Wed, May 21, 2008 at 09:49:27AM -0300, Glauber Costa wrote:
> > probably andi has a better idea on why it was added, since it used to 
> > live in his tree?
> 
> d_a_c() tries a couple of zones, and running the oom killer for each
> is inconvenient. Especially for the 16MB DMA zone which is unlikely
> to be cleared by the OOM killer anyways because normal user applications
> don't put pages in there. There was a real report with some problems
> in this area.

Can you give some pointers please ?

Thanks,
	tglx


