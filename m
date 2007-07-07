Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbXGGVKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbXGGVKx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 17:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXGGVKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 17:10:43 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53826 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751955AbXGGVKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 17:10:40 -0400
Date: Sat, 7 Jul 2007 23:11:10 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Patrick Caulfield <pcaulfie@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>, teigland@redhat.com,
       cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 regression fix] DLM must depend on SYSFS
Message-ID: <20070707211110.GL3492@stusta.de>
References: <20070707041402.GE3492@stusta.de> <alpine.LFD.0.999.0707071350380.31544@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707071350380.31544@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 01:51:55PM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 7 Jul 2007, Adrian Bunk wrote:
> >
> > The dependency of DLM on SYSFS got lost in
> > commit 6ed7257b46709e87d79ac2b6b819b7e0c9184998 resulting in the 
> > following compile error with CONFIG_DLM=y, CONFIG_SYSFS=n:
> 
> Hmm. Shouldn't we make that a "select", the way we already do for 
> CONFIGFS_FS? 

"select" is more user friendly while "depends on" makes it easier to 
disable options.

Usually I'm for the usage of "select" in such cases, but since this is 
with CONFIG_EMBEDDED=y where users can be expected to know better what 
they are doing I'd say a "depends on" is fine.

CONFIGFS_FS as a helper for some few file systems is also a different 
situation from SYSFS that is a dependency of much more options.

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

