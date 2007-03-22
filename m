Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639AbXCVC1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbXCVC1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 22:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbXCVC1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 22:27:07 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:40302 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbXCVC1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 22:27:06 -0400
X-IronPort-AV: i="4.14,310,1170651600"; 
   d="scan'208"; a="32081467:sNHT23504481"
Subject: Re: [PATCH -mm 1/4] Blackfin: architecture update patch
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu@analog.com, Bryan <bryan.wu@analog.com>, Arnd Bergmann <arnd@arndb.de>,
       Paul Mundt <lethal@linux-sh.org>,
       bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <20070321155324.a7d2d75a.akpm@linux-foundation.org>
References: <1174472363.5648.58.camel@roc-desktop>
	 <20070321155324.a7d2d75a.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 22 Mar 2007 10:24:51 +0800
Message-Id: <1174530291.20061.9.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 15:53 -0700, Andrew Morton wrote:
> On Wed, 21 Mar 2007 18:19:23 +0800
> "Wu, Bryan" <bryan.wu@analog.com> wrote:
> 
> > 1) Some issues are fixed according to LKML patch review.
> > 2) Remove not supported BF535 code
> > 3) Fixed some bugs from blackfin.uclinux.org SVN update
> > Here is the updated patch for 2.6.21-rc4-mm1
> 
> 1 out of 1 hunk FAILED -- saving rejects to file include/asm-blackfin/cplbinit.h.rej
> 1 out of 1 hunk FAILED -- saving rejects to file include/asm-blackfin/mach-bf535/bf535.h.rej
> 1 out of 1 hunk FAILED -- saving rejects to file include/asm-blackfin/scatterlist.h.rej
> 
> This seems to be against a kernel which did not include
> blackfin-arch-balance-parenthesis-in-macros.patch.  But 2.6.21-rc4-mm1 did
> include blackfin-arch-balance-parenthesis-in-macros.patch, so I'm not sure
> what is going on here.
> 

Sorry for this mess up. you know, as
blackfin-arch-balance-parenthesis-in-macros.patch was posted, it was
applied to our SVN tree. And I just merged these weeks SVN change to
this update patch. So this patch includes
blackfin-arch-balance-parenthesis-in-macros.patch. 

Please hold on, after I fixed some issues according to Arnd and Paul's
latest review, a new update patch will be sent.

Sorry for send a all-in-one update patch. Arnd and Paul gave lots' of
good ideas about our last blackfin-arch.patch last time, and most of
their request are applied in this days. So if I split the all-in-one
update patch to small fix, there will be maybe 20 or 30 patches.

After this blackfin-arch-update.patch was merged to -mm, I will post
small fixed patches as Arnd's advise.

Thanks
-Bryan Wu
