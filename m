Return-Path: <linux-kernel-owner+w=401wt.eu-S965741AbXCVFtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965741AbXCVFtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 01:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965764AbXCVFtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 01:49:25 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:19191 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965741AbXCVFtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 01:49:24 -0400
X-IronPort-AV: i="4.14,310,1170651600"; 
   d="scan'208"; a="25141186:sNHT23577113"
Subject: Re: [PATCH -mm 1/4] Blackfin: architecture update patch
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bryan.wu@analog.com, Arnd Bergmann <arnd@arndb.de>,
       Paul Mundt <lethal@linux-sh.org>,
       bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <20070321200835.275cdb67.akpm@linux-foundation.org>
References: <1174472363.5648.58.camel@roc-desktop>
	 <20070321155324.a7d2d75a.akpm@linux-foundation.org>
	 <1174530291.20061.9.camel@roc-desktop>
	 <20070321200835.275cdb67.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 22 Mar 2007 13:47:53 +0800
Message-Id: <1174542473.20061.23.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 20:08 -0800, Andrew Morton wrote:
> On Thu, 22 Mar 2007 10:24:51 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:
> 
> > > 1 out of 1 hunk FAILED -- saving rejects to file include/asm-blackfin/cplbinit.h.rej
> > > 1 out of 1 hunk FAILED -- saving rejects to file include/asm-blackfin/mach-bf535/bf535.h.rej
> > > 1 out of 1 hunk FAILED -- saving rejects to file include/asm-blackfin/scatterlist.h.rej
> > > 
> > > This seems to be against a kernel which did not include
> > > blackfin-arch-balance-parenthesis-in-macros.patch.  But 2.6.21-rc4-mm1 did
> > > include blackfin-arch-balance-parenthesis-in-macros.patch, so I'm not sure
> > > what is going on here.
> > > 
> > 
> > Sorry for this mess up. you know, as
> > blackfin-arch-balance-parenthesis-in-macros.patch was posted, it was
> > applied to our SVN tree. And I just merged these weeks SVN change to
> > this update patch. So this patch includes
> > blackfin-arch-balance-parenthesis-in-macros.patch. 
> 
> Well, you'd better get used to it.  As I told you a few weeks ago, once this
> code is merged into mainline you no longer own the master copy of the blackfin
> tree - Linus does.
> 

We agree with this and please give us sometime to try to push our
patches to the mainline tree. We still have tons of code should be
submitted to mainline, and before the submission, the code should be
reviewed and fixed. This is my main task and I think this internal
review can reduce you and other kernel maintainer's effort.

But our team still have release pressure from customers. The whole
distribution including bootloader/toolchain/kernel/uClinux-dist should
be delivered to customers on time. If our kernel blackfin-arch are
merged eventually, we definitely will move to linus tree and ask our
customer to use linus mainline tree.

As you know, our latest U-Boot blackfin code is accepted by U-Boot
upstream mainline recently. Then the internal U-Boot SVN tree will be
replaced by upstream git-blackfin tree in U-Boot, our development will
move to that mainline tree.

At this moment, I will try my best to speed up the blackfin-arch and
drivers merge progress. 

> If you're not careful, you'll end up submitting patches which revert other
> people's fixes.   And there's an excellent chance that you will submit patches
> which have dependencies on other stuff in your private tree and which are
> insufficiently-tested-against, and possibly incorrect-against Linus's tree.

Apologise. I will resend the blackfin update patch based on other
patches.

Thanks Andrew
-Bryan Wu
