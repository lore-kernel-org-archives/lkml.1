Return-Path: <linux-kernel-owner+w=401wt.eu-S1761270AbXJZBT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761270AbXJZBT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbXJZBTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:19:22 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51845 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752665AbXJZBTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:19:21 -0400
Date: Fri, 26 Oct 2007 03:19:50 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/cgroup.c: remove dead code
Message-ID: <20071026011950.GA30533@stusta.de>
References: <20071024162534.GZ30533@stusta.de> <6599ad830710240930r6649dec0q21b8c00f7d8a796a@mail.gmail.com> <20071024103411.dfd3ae04.pj@sgi.com> <6599ad830710251810r6bb1e390nf3612031af8b6767@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6599ad830710251810r6bb1e390nf3612031af8b6767@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 06:10:24PM -0700, Paul Menage wrote:
> On 10/24/07, Paul Jackson <pj@sgi.com> wrote:
> > Paul M wrote:
> > > I think I'd rather not make this change - if we later changed the size
> > > of release_agent_path[] this could silently fail. Can we get around
> > > the coverity checker somehow?
> >
> > Perhaps we can simplify this check then, to:
> >
> >   BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX));
> >
> > Less runtime code.
> 
> Sounds reasonable to me. Is there any kind of compile-time assert
> macro in the kernel?

BUILD_BUG_ON()

> Paul

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

