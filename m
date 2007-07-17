Return-Path: <linux-kernel-owner+w=401wt.eu-S934624AbXGQTVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934624AbXGQTVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbXGQTVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:21:21 -0400
Received: from waste.org ([66.93.16.53]:41209 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617AbXGQTVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:21:20 -0400
Date: Tue, 17 Jul 2007 14:21:01 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lindsay Roberts <lindsay.roberts.os@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, celinux-dev@tree.celinuxforum.org
Subject: Re: [PATCH] fs: Add romfs version 2
Message-ID: <20070717192100.GE11166@waste.org>
References: <8734b7880707122301m400294d4nf12072f949c95fa4@mail.gmail.com> <20070717013635.d6d0b124.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717013635.d6d0b124.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 01:36:35AM -0700, Andrew Morton wrote:
> On Fri, 13 Jul 2007 16:01:48 +1000 "Lindsay Roberts" <lindsay.roberts.os@gmail.com> wrote:
> 
> > * Increases romfs partition size limit from 2GB to 4GB.

That seems worthwhile.

> > * Adds new derivative of romfs filesystem (rom2fs) with
> >   block aligned regular file data to bring performance
> >   parity with ext2/3. This is about 225% of the read
> >   speed of the existing romfs.

Doesn't that make these filesystems much bigger? By, on average, .5k
per file? Or, if I'm understanding things correctly, ~1k?

-- 
Mathematics is the supreme nostalgia of our time.
