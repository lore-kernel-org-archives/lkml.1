Return-Path: <linux-kernel-owner+w=401wt.eu-S1761888AbZJNPJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761888AbZJNPJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761877AbZJNPJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:09:29 -0400
Received: from www.tglx.de ([62.245.132.106]:50044 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761872AbZJNPJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:09:28 -0400
Date: Wed, 14 Oct 2009 17:06:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg Ungerer <gerg@snapgear.com>
cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, Mike Frysinger <vapier@gentoo.org>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH 5/6 RFC] arch/m68knommu/kernel/process.c: Remove the BKL
 from sys_execve
In-Reply-To: <4AD45A06.2090606@snapgear.com>
Message-ID: <alpine.LFD.2.00.0910141706070.9428@localhost.localdomain>
References: <alpine.LFD.2.00.0910122350140.3658@localhost.localdomain> <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain> <alpine.LFD.2.00.0910130008320.3658@localhost.localdomain> <alpine.LFD.2.00.0910130010000.3658@localhost.localdomain>
 <alpine.LFD.2.00.0910130011180.3658@localhost.localdomain> <alpine.LFD.2.00.0910130014520.3658@localhost.localdomain> <4AD45A06.2090606@snapgear.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Oct 2009, Greg Ungerer wrote:

> Hi John,
> 
> On 10/13/2009 08:34 AM, John Kacur wrote:
> > > From e36c53d296132bc0ddbf6d9fb43ea5ea56dbd4a2 Mon Sep 17 00:00:00 2001
> > From: John Kacur<jkacur@redhat.com>
> > Date: Mon, 12 Oct 2009 23:37:28 +0200
> > Subject: [PATCH] arch/m68knommu/kernel/process.c: Remove the BKL from
> > sys_execve
> > 
> > This looks like a copy-and-paste of functionality that no-longer needs the
> > bkl.
> > Just remove it.
> > 
> > Signed-off-by: John Kacur<jkacur@redhat.com>
> 
> Tested and runs fine on m68knommu.
> 
> Acked-by: Greg Ungerer <gerg@uclinux.org>
> 
> Do you want me to push this into the m68knommu git tree,
> for eventual merging into Linus' tree?  Or are you going
> to push the whole set of patches together?

I'm collecting and pushing the BKL stuff, but if you want to take it
just let me know and I drop it.
 
Thanks,

	tglx
