Return-Path: <linux-kernel-owner+w=401wt.eu-S1765279AbZAQQyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765279AbZAQQyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbZAQQyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:54:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:37036 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328AbZAQQyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:54:08 -0500
Subject: Re: [GIT PULL -tip] x86: fix 22 make headers_check warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090117164747.GA7192@localhost>
References: <1232209856.3388.5.camel@localhost.localdomain>
	 <20090117164108.GG10825@elte.hu>  <20090117164747.GA7192@localhost>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 22:23:44 +0530
Message-Id: <1232211224.3966.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 19:47 +0300, Cyrill Gorcunov wrote:
> [Ingo Molnar - Sat, Jan 17, 2009 at 05:41:08PM +0100]
> | 
> | * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> | 
> | > Hello Ingo,
> | > 
> | > The following changes since commit 206e00df0967f6e91d792df7f1d4ff352eb42f8f:
> | >   Ingo Molnar (1):
> | >         Merge branch 'x86/urgent'
> | > 
> | > are available in the git repository at:
> | > 
> | >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master
> | > 
> | > Jaswinder Singh Rajput (8):
> | >       x86: boot.h fix make headers_check
> | >       x86: e820.h fix make headers_check
> | >       x86: kvm.h fix make headers_check
> | >       x86: mce.h fix make headers_check
> | >       x86: mtrr.h fix make headers_check
> | >       x86: ptrace-abi.h fix make headers_check
> | >       x86: sigcontext.h fix make headers_check
> | >       x86: swab.h fix make headers_check
> | > 
> | >  arch/x86/include/asm/boot.h       |    2 ++
> | >  arch/x86/include/asm/e820.h       |   11 ++++++++---
> | >  arch/x86/include/asm/kvm.h        |    2 +-
> | >  arch/x86/include/asm/mce.h        |    5 +----
> | >  arch/x86/include/asm/mtrr.h       |    1 +
> | >  arch/x86/include/asm/ptrace-abi.h |    5 ++++-
> | >  arch/x86/include/asm/sigcontext.h |    2 +-
> | >  arch/x86/include/asm/swab.h       |   21 +++++++++++++++++++--
> | >  8 files changed, 37 insertions(+), 12 deletions(-)
> | 
> | Pulled into tip/core/header-fixes and started testing them, thanks 
> | Jaswinder!
> | 
> | 	Ingo
> | 
> 
> I thought some of them I've already fixed, no?
> 

I just prepared these patches now based on the latest -tip and try to
remove all the remaining warnings for x86 headers files:

  INSTALL include/asm (52 files)
  CHECK   include/asm (52 files)

Thanks
--
JSR


