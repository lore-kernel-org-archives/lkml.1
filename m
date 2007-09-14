Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbXINFtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbXINFtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 01:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXINFtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 01:49:08 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:46703 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbXINFtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 01:49:06 -0400
X-IronPort-AV: i="4.20,253,1186372800"; 
   d="scan'208"; a="51412306:sNHT25836342"
Subject: Re: [Uclinux-dist-devel] Re: [PATCH] Blackfin arch: add some
	missing syscall
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: bryan.wu@analog.com, Mike Frysinger <vapier.adi@gmail.com>,
       bernd.schmidt@analog.com, linux-arch@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <46E918FD.3070607@t-online.de>
References: <1189670203.30686.15.camel@roc-desktop>
	 <20070913081852.GC17367@parisc-linux.org>
	 <8bd0f97a0709130137l55977c28w95cf8527ae8b9e24@mail.gmail.com>
	 <1189673849.30686.28.camel@roc-desktop>  <46E918FD.3070607@t-online.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 14 Sep 2007 13:45:18 +0800
Message-Id: <1189748718.5133.23.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 14 Sep 2007 05:49:04.0838 (UTC) FILETIME=[F588A660:01C7F692]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 13:03 +0200, Bernd Schmidt wrote:
> Bryan Wu wrote:
> >>> but mremap doesn't -- there's even an implementation in mm/nommu.c.
> >>> Could you check the rest of these over to see if they truly don't need
> >>> to be implemented for no-mmu?
> >> you're right we want mremap, my fault
> >>
> > 
> > Yes, I do think so, both sys_mremap and sys_munmap are implemented in
> > mm/nommu.c. How do think of this, Bernd?
> 
> There's a mremap in nommu.c, but it doesn't do a lot that is useful. 
> With some further mm changes in our tree, it's little more than a fancy 
> way of saying munmap, and uClibc does not use it, so there's no 
> compelling need to have it in userspace.
> 

Make sense. So currently Blackfin uClinux use the mremap/munmap in
uClibc?

Thanks
-Bryan
