Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbYHQShb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbYHQShb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 14:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbYHQShX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 14:37:23 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:11119 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYHQShW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 14:37:22 -0400
Date: Sun, 17 Aug 2008 20:37:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jeff Mahoney <jeffm@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: Fix creation of include2/asm symlink
Message-ID: <20080817183714.GA18976@uranus.ravnborg.org>
References: <s5hod3u5r3d.wl%tiwai@suse.de> <20080815194954.GA18377@uranus.ravnborg.org> <s5hskt5nxfs.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hskt5nxfs.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 11:03:51AM +0200, Takashi Iwai wrote:
> At Fri, 15 Aug 2008 21:49:54 +0200,
> Sam Ravnborg wrote:
> > 
> > On Fri, Aug 15, 2008 at 03:45:58PM +0200, Takashi Iwai wrote:
> > > The directory include2/asm can point wrongly to a non-existing
> > > directory on architectures that have moved include/asm under arch/*.
> > > 
> > > This patch fixes it by checking firstly whether arch/*/include/asm is
> > > available.
> > 
> > Hi Takashi.
> > 
> > I understand why you try to avoid include2/asm as it is not pretty.
> > And I had a similar patch once - but I dropped it as the symlink do
> > not harm and it will anyway be gone when the remaining architectures
> > has shifted to use arch/$ARCH/include/...
> > 
> > So I will not apply it.
> 
> Hm, OK.  Originally I fixed it because our build system has a sanity
> check against bogus symlinks and refused to package the latest kernel.
> If you don't want to put it in, we can keep it locally, of course.
> But, a bogus symlink is definitely not pretty...

It will go away as soon as all architextures are moved to use arch/$ARCH/include

	Sam
