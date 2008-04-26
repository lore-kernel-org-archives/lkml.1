Return-Path: <linux-kernel-owner+w=401wt.eu-S1759919AbYDZQp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919AbYDZQp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbYDZQpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:45:15 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58897 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbYDZQpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:45:14 -0400
Date: Sat, 26 Apr 2008 19:44:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kbuild@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in
	header file
Message-ID: <20080426164450.GK2252@cs181133002.pp.htv.fi>
References: <20080426134554.GA20727@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080426134554.GA20727@damson.getinternet.no>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 03:45:54PM +0200, Vegard Nossum wrote:
> Hi Sam,
> 
> Maybe something like this could be useful for cleaning up headers (and
> maintaining that cleanliness once it has been achieved). What do you think?
>...

And another note (after looking at the Cc list):

Header cleanup is *not* something suitable as a first task for a janitor.

The interesting cases are non-trivial.

And you need cross compilers for all architectures since fiddling with 
#include's under include/ breaks code left and right that only compiled 
due to some implicit #include (and if it still works due to another 
implicit #include on x86 the latter might not be present on all 
architectures).

> Vegard
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

