Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbXIIPCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbXIIPCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 11:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbXIIPCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 11:02:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49339 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbXIIPCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 11:02:00 -0400
Date: Sun, 9 Sep 2007 17:01:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, airlied@linux.ie
Subject: Re: X freezes kernel during exit [Re: 2.6.23-rc3-mm1]
Message-ID: <20070909150158.GD25798@one.firstfloor.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46D17A7A.70609@gmail.com> <46D409FC.1070305@gmail.com> <46E3DCB8.5010709@gmail.com> <20070909054751.cbb27081.akpm@linux-foundation.org> <46E3FE6B.7010209@gmail.com> <20070909141730.GB25798@one.firstfloor.org> <46E4028E.9050007@gmail.com> <20070909143324.GC25798@one.firstfloor.org> <46E40699.7060000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E40699.7060000@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 04:43:37PM +0200, Jiri Slaby wrote:
> On 09/09/2007 04:33 PM, Andi Kleen wrote:
> > On Sun, Sep 09, 2007 at 04:26:22PM +0200, Jiri Slaby wrote:
> >> BTW it is reproducible for me on two different machines (i386-x86_64,
> >> radeon-intel), don't you have the problem too?
> > 
> > No problems here with a radeon, no.
> > 
> > Does your CPU have clflush or not in /proc/cpuinfo?
> 
> BTW this is how my flush_kernel_map looks like:

Can you stick a printk into change_page_attr to log in which order
it changes pages (including their addresses and the pgattr)? 

-Andi 
