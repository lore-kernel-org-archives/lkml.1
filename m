Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbXH0XRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbXH0XRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 19:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbXH0XRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 19:17:39 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34628 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753222AbXH0XRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 19:17:38 -0400
Date: Tue, 28 Aug 2007 01:17:38 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070827231738.GP26410@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070827212723.GM4121@stusta.de> <20070827155302.47ba71e2@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070827155302.47ba71e2@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 03:53:02PM -0700, Arjan van de Ven wrote:
> On Mon, 27 Aug 2007 23:27:23 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
> > >...
> > > Changes since 2.6.23-rc2-mm2:
> > >...
> > >  git-alsa.patch
> > >...
> > >  git trees
> > >...
> > 
> > sys_{open,read} can finally be unexported.
> > 
> 
> isn't sys_close in the same boat?

Still used in fs/binfmt_misc.c ...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

