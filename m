Return-Path: <linux-kernel-owner+w=401wt.eu-S1759676AbXF0Qj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbXF0Qj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbXF0Qju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:39:50 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42279 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752209AbXF0Qjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:39:49 -0400
Date: Wed, 27 Jun 2007 18:40:12 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: sam@ravnborg.org, arjan@infradead.org, linux-kernel@vger.kernel.org,
       schilling@fokus.fraunhofer.de
Subject: Re: Linux Kernel include files
Message-ID: <20070627164012.GQ1094@stusta.de>
References: <46826d13.44vmeDzVCWEJhtNJ%Joerg.Schilling@fokus.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46826d13.44vmeDzVCWEJhtNJ%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 03:58:43PM +0200, Joerg Schilling wrote:
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Mon, Jun 25, 2007 at 04:53:55PM +0200, Joerg Schilling wrote:
> > > 
> > > star needs "ext2_fs.h". This file is not usable at all on many Linux 
> > > distributions, even with GCC.
> >
> > I was curious so I did:
> >
> > $ mkdir ~/foo
> > $ cd ~/kernel/linux-2.6
> > $ make INSTALL_HDR_PATH=~/foo
> > $ cd ~/foo
> > $ cat j.c
> > #include <stdio.h>
> > #include "etx2_fs.h"
> >
> > main()
> > {
> > 	printf("helloo\n");
> > }
> >
> > $ gcc -o j j.c
> > => No warning, no errors
> >
> 
> On Suse Linux 10.0, I get e.g.:
> 
> cat t.c
> #include <stdio.h>
> #include <linux/ext2_fs.h>
> 
> gcc -c t.c
> In file included from /usr/include/linux/ext2_fs.h:20,
>                  from t.c:2:
> /usr/include/linux/ext2_fs_sb.h:40: error: syntax error before âuid_tâ
> /usr/include/linux/ext2_fs_sb.h:49: error: syntax error before âs_next_generationâ
> /usr/include/linux/ext2_fs_sb.h:51: error: syntax error before â*â token
> /usr/include/linux/ext2_fs_sb.h:56: error: syntax error before â}â token

Already fixed since kernel 2.6.18.

Our header were a mess and we are working on getting them better.
But we can't timetravel and fix old distributions.

> Jörg

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

