Return-Path: <linux-kernel-owner+w=401wt.eu-S1945980AbXBBQgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945980AbXBBQgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 11:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945981AbXBBQgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 11:36:18 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58291 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1945980AbXBBQgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 11:36:17 -0500
Date: Fri, 2 Feb 2007 17:36:20 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Rob Landley <rob@landley.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sed s/gawk/awk/ scripts/gen_init_ramfs.sh
Message-ID: <20070202163620.GG3754@stusta.de>
References: <200701151624.18033.rob@landley.net> <20070115221146.GA12698@uranus.ravnborg.org> <20070123164944.db8acbad.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070123164944.db8acbad.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 04:49:44PM -0800, Andrew Morton wrote:
> On Mon, 15 Jan 2007 23:11:46 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Mon, Jan 15, 2007 at 04:24:17PM -0500, Rob Landley wrote:
> > > Signed-off-by: Rob Landley <rob@landley.net>
> > Acked-by: Sam Ravnborg <sam@ravnborg>
> > 
> > > Use "awk" instead of "gawk".
> > > 
> > > -- 
> > > 
> > > There's a symlink from awk to gawk if you're using the gnu tools, but no
> > > symlink from gawk to awk if you're using BusyBox or some such.  (There's a
> > > reason for the existence of standard names.  Can we use them please?)
> 
> If the kernel is being compiled on a non-Linux system (eg: legacy Unix)
> then it is, I guess, possible for `awk' and `gawk' to offer different
> features.  If the kernel's use of gawk uses GNU extensions then this patch
> might break things on such a system.
> 
> I guess we'll find out...

Not only legacy systems.

E.g. in Debian GNU/Linux you must have at least one AWK implementation 
installed, and awk is a symlink to one of them (both is done by the 
package manager).

Available AWK implementations are:
- GNU AWK 
- Mawk
- the original AWK

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

