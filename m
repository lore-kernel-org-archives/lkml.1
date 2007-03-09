Return-Path: <linux-kernel-owner+w=401wt.eu-S2992979AbXCIFfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992979AbXCIFfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 00:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992983AbXCIFfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 00:35:44 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53816 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992979AbXCIFfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 00:35:43 -0500
Date: Fri, 9 Mar 2007 06:35:45 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, Jan Beulich <jbeulich@novell.com>,
       Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Moore <dcm@mit.edu>
Subject: Re: [patch 00/21] 2.6.19-stable review
Message-ID: <20070309053545.GT3441@stusta.de>
References: <20070221013619.GA30227@kroah.com> <45DC4AE8.7050704@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <45DC4AE8.7050704@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 02:36:40PM +0100, Stefan Richter wrote:
> Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.19.5 release.
> > 
> > This will probably be the last release of the 2.6.19-stable series, so
> > if there are patches that you feel should be applied to that tree,
> > please let me know.
> 
> There is one here: "Missing critical phys_to_virt in lib/swiotlb.c".
> http://lkml.org/lkml/2007/2/4/116
> It fixes a DMA related bug which was seen with a variety of drivers
> especially on EM64T machines with more than 3GB RAM. I hope you can
> extract the patch from this MIME attachment.
> 
> Adrian, AFAICS it applies as-is to 2.6.16.y too. I don't have a machine
> to test personally, but it is quite obvious.

Thanks.

It applies fine and it's now in my tree.

> The mentioned bigger patch has been merged by Linus between 2.6.20 and
> 2.6.21-rc1.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

