Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbXIROKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbXIROKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757310AbXIROKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:10:25 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37529 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757268AbXIROKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:10:23 -0400
Date: Tue, 18 Sep 2007 16:10:36 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, akpm@linux-foundation.org, perex@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070918141036.GE27980@stusta.de>
References: <20070909202527.GT3563@stusta.de> <20070909203920.GA11764@infradead.org> <20070910.051838.41660444.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070910.051838.41660444.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 05:18:38AM -0700, David Miller wrote:
> From: Christoph Hellwig <hch@infradead.org>
> Date: Sun, 9 Sep 2007 21:39:20 +0100
> 
> > On Sun, Sep 09, 2007 at 10:25:28PM +0200, Adrian Bunk wrote:
> > > sys_{open,read} can finally be unexported.
> > 
> > Andrew, can you please put this in?  Having these exports for syscalls around
> > hsa been a long-time annoyance that can finally be fixed now.
> 
> I'm happy to see this go too, but please add the necessary
> export to arch/sparc64/kernel/sparc64_ksyms.S so that the
> solaris system call table reference in
> arch/sparc64/solaris/systbls.S can be satisfied.
>...

This module calls neither sys_open() nor sys_read() directly.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

