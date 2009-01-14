Return-Path: <linux-kernel-owner+w=401wt.eu-S1759450AbZANUyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450AbZANUyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbZANUyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:54:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35924 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbZANUyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:54:01 -0500
Date: Wed, 14 Jan 2009 15:53:57 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Valdis.Kletnieks@vt.edu, Kyle McMartin <kyle@infradead.org>,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: kzalloc mod->ref
Message-ID: <20090114205357.GA25473@bombadil.infradead.org>
References: <20090114033533.GL25103@bombadil.infradead.org> <s5hmydufe3c.wl%tiwai@suse.de> <20090114155859.GO25103@bombadil.infradead.org> <s5hiqoh7t38.wl%tiwai@suse.de> <24465.1231961348@turing-police.cc.vt.edu> <s5h63khei9t.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h63khei9t.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 09:37:18PM +0100, Takashi Iwai wrote:
> At Wed, 14 Jan 2009 14:29:08 -0500,
> Valdis.Kletnieks@vt.edu wrote:
> > 
> > On Wed, 14 Jan 2009 17:25:31 +0100, Takashi Iwai said:
> > 
> > > We can use nr_cpu_ids instead of NR_CPUS.
> > > For a machine like 4096 CPUs, such an amount of memory is like a
> > > peanut :)
> > 
> > It's not peanuts if you're dealing with a distro kernel that's essentially
> > forced to compile with NR_CPUS=<some moby integer>, but booting on a single or
> > dual core system with possibly not even 1G of memory.
> 
> My suggestion above is to use nr_cpu_ids, which is the actual number
> of CPUs, not a constant like NR_CPUS.
> 

Yes, I agree that it's a better solution, since I suppose it's based on
cpu_possible_mask as opposed to, well, the maximum possible.

I'll fire off an updated patch. Let's see what rusty thinks.

cheers, Kyle
