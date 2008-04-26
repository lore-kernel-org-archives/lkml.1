Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbYDZQil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbYDZQil (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbYDZQic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:38:32 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34705 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbYDZQib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:38:31 -0400
Date: Sat, 26 Apr 2008 19:38:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kbuild@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in
	header file
Message-ID: <20080426163808.GJ2252@cs181133002.pp.htv.fi>
References: <20080426134554.GA20727@damson.getinternet.no> <20080426161714.GR14990@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080426161714.GR14990@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 10:17:14AM -0600, Matthew Wilcox wrote:
> On Sat, Apr 26, 2008 at 03:45:54PM +0200, Vegard Nossum wrote:
> > Maybe something like this could be useful for cleaning up headers (and
> > maintaining that cleanliness once it has been achieved). What do you think?
> > 
> > Subject: [PATCH] headerdep: a tool for detecting inclusion cycles in header files
> 
> Do we actually have inclusion cycles in header files?
>...

Yes, e.g. between include/linux/vmstat.h and include/linux/mm.h that 
directly #include each other.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

