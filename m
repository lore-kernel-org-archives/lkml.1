Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbYEUIBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbYEUIBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757432AbYEUIBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:01:31 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43437 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406AbYEUIBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:01:30 -0400
Date: Wed, 21 May 2008 10:59:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: completely lost as to what to do, or where to look.
Message-ID: <20080521075917.GB18352@cs181133002.pp.htv.fi>
References: <dd18b0c30805202110x7c412b3bq523f91d968072482@mail.gmail.com> <20080520223410.9a8f200d.akpm@linux-foundation.org> <dd18b0c30805202351h133147adg5bb526e3f74e3bd6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dd18b0c30805202351h133147adg5bb526e3f74e3bd6@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 06:51:24AM +0000, Justin Mattock wrote:
> On Wed, May 21, 2008 at 5:34 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Wed, 21 May 2008 04:10:16 +0000 "Justin Mattock" <justinmattock@gmail.com> wrote:
> >
> >> Hello; I'm lost as to where to look in the kernel, as to why I'm
> >> receiving a black screen with startx
> >> DRI seems to be fine, I'm noticing a sema_init but am not sure if this
> >> is the cause of the blackness.
> >> any direction as to where I might look would be helpful.
> >
> > Kernel version?
> >
> > A git-bisect should get you down the the offending commit within an
> > hour or three.  http://www.kernel.org/doc/local/git-quick.html has some
> > instructions.
> >
> > But if you're on 2.6.26-rcX, be sure to use the very latest - a pile of
> > bad DRI code got reverted recently.  This morning, I think.
> >
> 
> Thanks for the help, From what I can remember I noticed this around
> 2.6.26-rc1. It could be an issue with DRI, but then again it could be
> something else. With running some more tests I'm noticing  a conflict
> with libdri.so, not recognizing the module or the module not
> recognizing libdri.so.
>...

Which X video driver are you using?

What exactly is the error message?

> regards;
> Justin P. Mattock

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

