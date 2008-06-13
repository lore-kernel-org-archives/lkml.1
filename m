Return-Path: <linux-kernel-owner+w=401wt.eu-S1761609AbYFMNXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609AbYFMNXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 09:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbYFMNX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 09:23:26 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55370 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbYFMNXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 09:23:25 -0400
Date: Fri, 13 Jun 2008 16:22:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: yasutake.koichi@jp.panasonic.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] mn10300: export kernel_thread
Message-ID: <20080613132213.GA21341@cs181133002.pp.htv.fi>
References: <20080612221143.GR17231@cs181133002.pp.htv.fi> <29145.1213362676@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <29145.1213362676@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 02:11:16PM +0100, David Howells wrote:
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > --- a/arch/mn10300/kernel/mn10300_ksyms.c
> > +++ b/arch/mn10300/kernel/mn10300_ksyms.c
> 
> Why put it here?

Because I was blind....

> It should really go with the definition of kernel_thread()
> in arch/mn10300/kernel/process.c.
> 
> I've just posted my own patch to deal with this and empty_zero_page.  I also
> submitted an additional patch to provide __ucmpdi2() so that allmodconfig
> builds for me.

Thanks!

> David

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

