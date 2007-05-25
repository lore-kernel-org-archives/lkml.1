Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbXEYGoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbXEYGoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 02:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbXEYGoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 02:44:09 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751917AbXEYGoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 02:44:08 -0400
Date: Thu, 24 May 2007 23:43:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "young dave" <hidave.darkstar@gmail.com>
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Anton Altaparmakov" <aia21@cantab.net>
Subject: Re: 2.6.22-rc2-mm1 NTFS & SLUB related fix
Message-Id: <20070524234353.ad493d42.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0705242327q48c5d449p2fc028c40b0bfb08@mail.gmail.com>
References: <a8e1da0705242201r13a26d92hcb0059f55e15a24a@mail.gmail.com>
	<Pine.LNX.4.64.0705242202340.1327@schroedinger.engr.sgi.com>
	<a8e1da0705242222n2414a66bo97d20c82c6a497e4@mail.gmail.com>
	<20070524224709.0719acfe.akpm@linux-foundation.org>
	<a8e1da0705242327q48c5d449p2fc028c40b0bfb08@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 06:27:51 +0000 "young dave" <hidave.darkstar@gmail.com> wrote:

> Hi  Andrew,
> 
> > So I think this was meant:
> >
> > --- a/fs/ntfs/inode.c~a
> > +++ a/fs/ntfs/inode.c
> > @@ -140,7 +140,7 @@ static int ntfs_init_locked_inode(struct
> >                 if (!ni->name)
> >                         return -ENOMEM;
> >                 memcpy(ni->name, na->name, i);
> > -               ni->name[i] = 0;
> > +               ni->name[na->name_len] = 0;
> >         }
> >         return 0;
> >  }
> > _
> >
> 
> I tested it , it doesn't work.

Surprised.  Are you really sure that you had the patch applied, and that you
tested the right kernel, etc?
