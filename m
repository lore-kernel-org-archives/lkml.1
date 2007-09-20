Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbXITFxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbXITFxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 01:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbXITFxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 01:53:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32774 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754300AbXITFxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 01:53:24 -0400
Date: Wed, 19 Sep 2007 22:53:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, amitkale@linsyssoft.com,
       trini@kernel.crashing.org
Subject: Re: 2.6.23-rc6-mm1 powerpc - kgdb is broken
Message-Id: <20070919225300.8c41a2e5.akpm@linux-foundation.org>
In-Reply-To: <18162.967.558342.829193@cargo.ozlabs.ibm.com>
References: <46F114D2.40809@linux.vnet.ibm.com>
	<46F1700D.2020205@windriver.com>
	<20070919123629.05e3a06c.akpm@linux-foundation.org>
	<18162.967.558342.829193@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 15:23:19 +1000 Paul Mackerras <paulus@samba.org> wrote:

> Andrew Morton writes:
> 
> > On Wed, 19 Sep 2007 13:53:01 -0500 Jason Wessel <jason.wessel@windriver.com> wrote:
> > 
> > > I am not exactly sure how to fix this...
> > > 
> > > Another git tree is overriding the patch to include/asm-powerpc/kgdb.h
> > > in the -mm tree.   The patches as I provide them against 2.6.23-rc6 for
> > > KGDB work correctly for ppc/powerpc in 32 and 64 bit modes and compile
> > > correctly.
> > > 
> > > At issue is that someone merged a bogus copy of asm-ppc/kgdb.h from the
> > > git tree in -mm that is called: git-powerpc.patch.
> > 
> > Yeah, this was pointed out and largely ignored.
> > 
> > I'm afraid you'll have to wait until that powerpc stuff hits mainline
> > and then fix it all up.
> 
> I could remove all the kgdb support from arch/powerpc as a first step,
> if that would make it easier to pull in the new stuff...
> 

I don't know if/when the new stuff will be merged - it's missed 2.6.24.

It might be better to proceed as you intended.  Presumably it won't be too
hard to hack things back into shape.

