Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbXITFXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbXITFXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 01:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXITFXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 01:23:30 -0400
Received: from ozlabs.org ([203.10.76.45]:51493 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXITFXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 01:23:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18162.967.558342.829193@cargo.ozlabs.ibm.com>
Date: Thu, 20 Sep 2007 15:23:19 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, amitkale@linsyssoft.com,
       trini@kernel.crashing.org
Subject: Re: 2.6.23-rc6-mm1 powerpc - kgdb is broken
In-Reply-To: <20070919123629.05e3a06c.akpm@linux-foundation.org>
References: <46F114D2.40809@linux.vnet.ibm.com>
	<46F1700D.2020205@windriver.com>
	<20070919123629.05e3a06c.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> On Wed, 19 Sep 2007 13:53:01 -0500 Jason Wessel <jason.wessel@windriver.com> wrote:
> 
> > I am not exactly sure how to fix this...
> > 
> > Another git tree is overriding the patch to include/asm-powerpc/kgdb.h
> > in the -mm tree.   The patches as I provide them against 2.6.23-rc6 for
> > KGDB work correctly for ppc/powerpc in 32 and 64 bit modes and compile
> > correctly.
> > 
> > At issue is that someone merged a bogus copy of asm-ppc/kgdb.h from the
> > git tree in -mm that is called: git-powerpc.patch.
> 
> Yeah, this was pointed out and largely ignored.
> 
> I'm afraid you'll have to wait until that powerpc stuff hits mainline
> and then fix it all up.

I could remove all the kgdb support from arch/powerpc as a first step,
if that would make it easier to pull in the new stuff...

Paul.
