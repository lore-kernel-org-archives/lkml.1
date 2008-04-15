Return-Path: <linux-kernel-owner+w=401wt.eu-S1763910AbYDOL0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763910AbYDOL0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 07:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757978AbYDOL0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 07:26:10 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:40090 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757762AbYDOL0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:26:09 -0400
Date: Tue, 15 Apr 2008 14:25:00 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?utf-8?B?PT9JU08tODg1OS0xP1E/?= Ilpo_J=E4rvinen ?= 
	<ilpo.jarvinen@helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] smb.h: uses struct timespec but didn't include
	linux/time.h
Message-ID: <20080415112500.GB2454@cs181133002.pp.htv.fi>
References: <Pine.LNX.4.64.0804151202390.17123@wrl-59.cs.helsinki.fi> <20080415021057.9bdff72f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080415021057.9bdff72f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 02:10:57AM -0700, Andrew Morton wrote:
> On Tue, 15 Apr 2008 12:04:04 +0300 (EEST) "Ilpo J__rvinen" <ilpo.jarvinen@helsinki.fi> wrote:
> 
> > 
> > Signed-off-by: Ilpo J__rvinen <ilpo.jarvinen@helsinki.fi>
> > ---
> >  include/linux/smb.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/smb.h b/include/linux/smb.h
> > index f098dff..caa43b2 100644
> > --- a/include/linux/smb.h
> > +++ b/include/linux/smb.h
> > @@ -11,6 +11,7 @@
> >  
> >  #include <linux/types.h>
> >  #include <linux/magic.h>
> > +#include <linux/time.h>
> >  
> >  enum smb_protocol { 
> >  	SMB_PROTOCOL_NONE, 
> 
> Did this actually cause a compilation error?

Even if it doesn't at the moment it should be fixed - these kind
of issues are why often adding or removing an #include in a header 
suddenly breaks some configuration on some other architecture.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

