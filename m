Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYJPKDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYJPKDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbYJPKDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:03:18 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58126 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491AbYJPKDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:03:15 -0400
Date: Thu, 16 Oct 2008 13:03:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org,
       netdev@vger.kernel.org, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, marek.vasut@gmail.com,
       David Woodhouse <dwmw2@infradead.org>,
       Mark Fasheh <mark.fasheh@oracle.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: powerpc allmodconfig
Message-ID: <20081016100306.GD23630@cs181140183.pp.htv.fi>
References: <20081015213337.a99a9595.akpm@linux-foundation.org> <s5h1vyhrsja.wl%tiwai@suse.de> <20081016073836.GB23630@cs181140183.pp.htv.fi> <s5hiqrtq8fc.wl%tiwai@suse.de> <20081016082157.GC23630@cs181140183.pp.htv.fi> <s5hod1lorpm.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <s5hod1lorpm.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 10:43:33AM +0200, Takashi Iwai wrote:
> At Thu, 16 Oct 2008 11:21:57 +0300,
> Adrian Bunk wrote:
> > 
> > On Thu, Oct 16, 2008 at 09:57:11AM +0200, Takashi Iwai wrote:
> > > At Thu, 16 Oct 2008 10:38:36 +0300,
> > > Adrian Bunk wrote:
> > > > 
> > > > On Thu, Oct 16, 2008 at 07:57:29AM +0200, Takashi Iwai wrote:
> > > > > At Wed, 15 Oct 2008 21:33:37 -0700,
> > > > > Andrew Morton wrote:
> > > > > > 
> > > > > > sound/soc/soc-dapm.c:1029: warning: 'snd_soc_dapm_connect_input' is deprecated (declared at sound/soc/soc-dapm.c:1026)
> > > > > > sound/soc/soc-dapm.c:1029: warning: 'snd_soc_dapm_connect_input' is deprecated (declared at sound/soc/soc-dapm.c:1026)
> > > > > 
> > > > > These are definitions of deprecated interfaces.
> > > > > We can remove it in 2.6.29.  If we don't want to be conservative, it
> > > > > can be removed in 2.6.28, too.
> > > > >...
> > > > 
> > > > Since it's an in-kernel API there's no reason to keep it once there are 
> > > > no users left.
> > > 
> > > Right.  But, IMO, now is no suitable time.
> > > A thing like API removal should have been tested in linux-next, and we
> > > had plenty of time indeed for 2.6.28.
> > >...
> > 
> > A grep through the tree and one test compile that covers 
> > sound/soc/soc-dapm.c should be enough testing.
> > 
> > And having it then in -next once should be enough to discover if someone 
> > wrongly added a new user.
> 
> My point is the time for removal.  The API changes should have been
> done in the merge window, and it should have been tested *before* the
> merge window.
>...

My point is simply that compared to many other patches that weren't 
tested before the merge window, and that still get (for various reasons) 
into the tree, the removal of unused functions is extremely low-risk 
(assuming the patch creator knows what grep is and does a test compile 
of the changed code).

> thanks,
> 
> Takashi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

