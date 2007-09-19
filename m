Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbXISThi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbXISThi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXISTha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:37:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50078 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbXISTh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:37:29 -0400
Date: Wed, 19 Sep 2007 12:36:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, amitkale@linsyssoft.com,
       trini@kernel.crashing.org
Subject: Re: 2.6.23-rc6-mm1 powerpc - kgdb is broken
Message-Id: <20070919123629.05e3a06c.akpm@linux-foundation.org>
In-Reply-To: <46F1700D.2020205@windriver.com>
References: <46F114D2.40809@linux.vnet.ibm.com>
	<46F1700D.2020205@windriver.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 13:53:01 -0500 Jason Wessel <jason.wessel@windriver.com> wrote:

> I am not exactly sure how to fix this...
> 
> Another git tree is overriding the patch to include/asm-powerpc/kgdb.h
> in the -mm tree.   The patches as I provide them against 2.6.23-rc6 for
> KGDB work correctly for ppc/powerpc in 32 and 64 bit modes and compile
> correctly.
> 
> At issue is that someone merged a bogus copy of asm-ppc/kgdb.h from the
> git tree in -mm that is called: git-powerpc.patch.

Yeah, this was pointed out and largely ignored.

I'm afraid you'll have to wait until that powerpc stuff hits mainline
and then fix it all up.
