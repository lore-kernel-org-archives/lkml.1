Return-Path: <linux-kernel-owner+w=401wt.eu-S965640AbXCVEI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965640AbXCVEI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 00:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965648AbXCVEI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 00:08:58 -0400
Received: from smtp.osdl.org ([65.172.181.24]:38316 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965640AbXCVEI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 00:08:57 -0400
Date: Wed, 21 Mar 2007 20:08:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: bryan.wu@analog.com
Cc: Wu@analog.com, Arnd Bergmann <arnd@arndb.de>,
       Paul Mundt <lethal@linux-sh.org>,
       bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/4] Blackfin: architecture update patch
Message-Id: <20070321200835.275cdb67.akpm@linux-foundation.org>
In-Reply-To: <1174530291.20061.9.camel@roc-desktop>
References: <1174472363.5648.58.camel@roc-desktop>
	<20070321155324.a7d2d75a.akpm@linux-foundation.org>
	<1174530291.20061.9.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 10:24:51 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:

> > 1 out of 1 hunk FAILED -- saving rejects to file include/asm-blackfin/cplbinit.h.rej
> > 1 out of 1 hunk FAILED -- saving rejects to file include/asm-blackfin/mach-bf535/bf535.h.rej
> > 1 out of 1 hunk FAILED -- saving rejects to file include/asm-blackfin/scatterlist.h.rej
> > 
> > This seems to be against a kernel which did not include
> > blackfin-arch-balance-parenthesis-in-macros.patch.  But 2.6.21-rc4-mm1 did
> > include blackfin-arch-balance-parenthesis-in-macros.patch, so I'm not sure
> > what is going on here.
> > 
> 
> Sorry for this mess up. you know, as
> blackfin-arch-balance-parenthesis-in-macros.patch was posted, it was
> applied to our SVN tree. And I just merged these weeks SVN change to
> this update patch. So this patch includes
> blackfin-arch-balance-parenthesis-in-macros.patch. 

Well, you'd better get used to it.  As I told you a few weeks ago, once this
code is merged into mainline you no longer own the master copy of the blackfin
tree - Linus does.

If you're not careful, you'll end up submitting patches which revert other
people's fixes.   And there's an excellent chance that you will submit patches
which have dependencies on other stuff in your private tree and which are
insufficiently-tested-against, and possibly incorrect-against Linus's tree.
