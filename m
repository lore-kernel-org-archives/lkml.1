Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbXITF3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbXITF3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 01:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXITF3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 01:29:07 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:53403 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbXITF3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 01:29:05 -0400
Message-Id: <46F204FD.6040303@mxs.nes.nec.co.jp>
Date: Thu, 20 Sep 2007 14:28:29 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Adrian Bunk <bunk@kernel.org>, kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 4/4] [-mm patch]  Add a prefix "VMCOREINFO_" to the vmcoreinfo
 macros.
References: <46E9F6A9.8060500@mxs.nes.nec.co.jp>	<46E9F942.5070007@mxs.nes.nec.co.jp> <20070914190350.011cdadb.akpm@linux-foundation.org>
In-Reply-To: <20070914190350.011cdadb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

Andrew Morton wrote:
> > On Fri, 14 Sep 2007 12:00:18 +0900 "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp> wrote:
> > 
>> >> [4/4] Add a prefix "VMCOREINFO_" to the vmcoreinfo macros.
>> >>    Old vmcoreinfo macros were defined as generic names SYMBOL/SIZE/OFFSET
>> >>    /LENGTH/CONFIG, and it is impossible to grep for them. So these names
>> >>    should be changed. This discussion is the following:
>> >>    http://www.ussg.iu.edu/hypermail/linux/kernel/0709.1/0415.html
> > 
> > I already had these patches, except for #4.
> > 
> > Your email client is space-stuffing the patches, so I have to do s/^ / /g
> > to apply them.  Please see
> > http://mbligh.org/linuxdocs/Email/Clients/Thunderbird and/or the
> > soon-to-be-merged Documentation/email-clients.txt

Sorry for wasting your time.
I changed my thunderbird's setting according to the above site.


> > I plan on folding all of
> > 
> > add-vmcoreinfo.patch
> > add-vmcore-cleanup-the-coding-style-according-to-andrews-comments.patch
> > add-vmcore-add-nodemask_ts-size-and-nr_free_pagess-value-to-vmcoreinfo_data.patch
> > add-vmcore-use-the-existing-ia64_tpa-instead-of-asm-code.patch
> > add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros.patch
> > 
> > into a single patch for upstream.

Thank you for merging them into linux-2.6.23-rc6-mm1.
Additionally, could you merge the following patches to clean up
add-vmcoreinfo.patch ?

[PATCH 5/4] [-mm patch] Rename macros returning the size.
 The #define SIZE() should be renamed STRUCT_SIZE() since it's always 
 returning the size of the struct with a given name.  This would allow 
 TYPEDEF_SIZE() to simply become SIZE() since it need not be used 
 exclusively for typedefs. This idea is David Rientjes's.
 http://www.ussg.iu.edu/hypermail/linux/kernel/0709.1/1964.html
 
[PATCH 6/4] [-mm patch] use the existing offsetof().
 It is better that offsetof() is used for VMCOREINFO_OFFSET().
 This idea is Joe Perches's.


Thanks
Ken'ichi Ohmichi 

