Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbXH0QEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbXH0QEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbXH0P66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:58:58 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43961 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758163AbXH0P64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:58:56 -0400
Date: Mon, 27 Aug 2007 17:58:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andrew Morgan <morgan@kernel.org>, chrisw@sous-sol.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [2.6 patch] remove securebits
Message-ID: <20070827155855.GE4121@stusta.de>
References: <20070824210649.GG30705@stusta.de> <20070824211942.GA24478@vino.hallyn.com> <46CFA6F2.9030209@kernel.org> <20070825182846.GN30705@stusta.de> <20070827150941.GA31042@vino.hallyn.com> <20070827151751.GD4121@stusta.de> <20070827152817.GA31632@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070827152817.GA31632@vino.hallyn.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 10:28:17AM -0500, Serge E. Hallyn wrote:
> Quoting Adrian Bunk (bunk@kernel.org):
> > On Mon, Aug 27, 2007 at 10:09:42AM -0500, Serge E. Hallyn wrote:
> > > Quoting Adrian Bunk (bunk@kernel.org):
> > > > On Fri, Aug 24, 2007 at 08:50:10PM -0700, Andrew Morgan wrote:
> > > > > 
> > > > > FWIW, in the mm kernel, I've actually already removed them when one
> > > > > configures without capabilities.
> > > > > 
> > > > > http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/broken-out/v3-file-capabilities-alter-behavior-of-cap_setpcap.patch
> > > > > 
> > > > > Other than writing a custom module, so far as I can tell, there is/was
> > > > > no way to set them anyway.
> > > > > 
> > > > > I'd obviously prefer to wait for the mm-merge process to complete and
> > > > > minimize the churn in this area, but I basically agree that the bits as
> > > > > implemented are pretty useless in their current form. In a per-process
> > > > > mode (with filesystem capability support) they are much more useful...
> > > > 
> > > > It was in the tree for nine years (sic) without a single user...
> > > 
> > > That's because without file capabilities there was no way for a process
> > > to retain capabilities across exec, so not having a privileged root user
> > > was simply not workable.
> > > 
> > > > Are you only improving a dead horse, or do you also have a rider for the 
> > > > improved dead horse?
> > > 
> > > It will allow process trees to run with strict capabilities, without a
> > > root user which automatically gains full capabilities.  That wasn't
> > > possible without file capabilities, since there was no way for processes
> > > to retain capabilities across exec.  Now that we have file capabilities,
> > > it is feasible, and it certainly is useful.
> > 
> > I didn't question that the dead horse gets improved, but where's the 
> > rider?
> > 
> > A user of the improved securebits has to be submitted for inclusion in 
> > the kernel.
> 
> The user would be userspace...
> 
> Unless by 'the user' you actually mean the patch itself which will allow
> the setting of secure_noroot per-process.  I don't know for sure, but
> suspect Andrew might like to wait until file capabilities make it into
> and stabilize in Linus' tree before going on with that.

That's what I am talking about.

This patch should be submitted and discussed together with the changes 
Andrew has for securebits.

> -serge

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

