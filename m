Return-Path: <linux-kernel-owner+w=401wt.eu-S1761921AbXF0PLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761921AbXF0PLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761280AbXF0PKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:10:55 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42103 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760833AbXF0PKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:10:52 -0400
Date: Wed, 27 Jun 2007 17:11:14 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Message-ID: <20070627151114.GM1094@stusta.de>
References: <20070626230756.519733902@suse.de> <20070626165202.bfe8e6df.akpm@linux-foundation.org> <20070627022403.GB14656@suse.de> <20070626194700.5b0ff477.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070626194700.5b0ff477.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 07:47:00PM -0700, Andrew Morton wrote:
> On Tue, 26 Jun 2007 19:24:03 -0700 John Johansen <jjohansen@suse.de> wrote:
> 
> > > 
> > > so...  where do we stand with this?  Fundamental, irreconcilable
> > > differences over the use of pathname-based security?
> > > 
> > There certainly seems to be some differences of opinion over the use
> > of pathname-based-security.
> 
> I was refreshed to have not been cc'ed on a lkml thread for once.  I guess
> it couldn't last.
> 
> Do you agree with the "irreconcilable" part?  I think I do.
> 
> I suspect that we're at the stage of having to decide between
> 
> a) set aside the technical issues and grudgingly merge this stuff as a
>    service to Suse and to their users (both of which entities are very
>    important to us) and leave it all as an object lesson in
>    how-not-to-develop-kernel-features.
> 
>    Minimisation of the impact on the rest of the kernel is of course
>    very important here.
> 
> versus
> 
> b) leave it out and require that Suse wear the permanent cost and
>    quality impact of maintaining it out-of-tree.  It will still be an
>    object lesson in how-not-to-develop-kernel-features.
>...

versus

c) if [1] AppArmor is considered to be something that wouldn't 
   be merged if it wasn't already widely deployed by Suse: leave it out, 
   work on an ideal solution [2], and let Suse wear the one-time cost
   of migrating their users to the ideal solution

One important point is that if AppArmor gets merged there will be much 
more distribution support for it, and many people on !Suse will start 
using it.

I'm not claiming to understand the technical details, but from both 
slightly reading over the previous discussions and the "What are the 
advantages of AppArmor over SELinux?" section in the AppArmor FAQ [3] my 
impression is that a main advantage of AppArmor are more user friendly 
userspace tools. Therefore, if [1] AppArmor is considered technically 
inferior to SELinux, it might still become more popular than SELinux 
simply because it's easier to use - and although it's technically 
inferior.

cu
Adrian

[1] note the "if"
[2] could be, but not necessarily, SELinux
[3] http://developer.novell.com/wiki/index.php/Apparmor_FAQ

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

