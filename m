Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbYDZPBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbYDZPBJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbYDZPAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:00:54 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59213 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbYDZPAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:00:53 -0400
Date: Sat, 26 Apr 2008 18:00:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kbuild@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in
	header file
Message-ID: <20080426150030.GH2252@cs181133002.pp.htv.fi>
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
> 
> (One thing which might or might not be good is that 'make headerdep' will
>  also compile using CC if they're not already compiled. If this should be
>  fixed, I think you'd know how to do it.)

This way you only catch problems in the current kernel configuration.

The only problems are under include/, and you should be able to do this 
by parsing all headers and without hooking into the build system.

> Vegard
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

