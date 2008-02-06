Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbYBFKuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbYBFKuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 05:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbYBFKup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 05:50:45 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:39518 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761902AbYBFKuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 05:50:44 -0500
Date: Wed, 6 Feb 2008 12:50:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Pavel Roskin <proski@gnu.org>
Cc: rms@gnu.org, linux-kernel@vger.kernel.org, jonathan@jonmasters.org,
       rusty@rustcorp.com.au, pgiri@yahoo.com
Subject: Re: ndiswrapper and GPL-only symbols redux
Message-ID: <20080206105051.GA13874@cs181133002.pp.htv.fi>
References: <1201641765.18773.35.camel@dv> <20080129225701.GS8767@does.not.exist> <1201650267.18773.118.camel@dv> <E1JKJvh-0006P8-Pi@fencepost.gnu.org> <1201842510.18433.88.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1201842510.18433.88.camel@dv>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 12:08:30AM -0500, Pavel Roskin wrote:
> On Wed, 2008-01-30 at 15:53 -0500, Richard Stallman wrote:
> > I don't know what the circumstances are in this case, since the
> > description quoted was quite sketchy.  I suggest that someone send a
> > clear description of the case to licensing@gnu.org to find out what
> > GPLv2 implies about it.
> 
> I don't think anyone implies that there are any real copyright issues
> with ndiswrapper, at least in the US.  With all differences in
> intonations, everybody seems to understand that.
> 
> It's understandable that kernel developers feel uncomfortable about
> ndiswrapper, which loads non-free Windows drivers into the kernel
> memory.  It's understandable that kernel developers don't want to
> support systems where such code has been running at any time.
> 
> It's understandable that ndiswrapper can be considered as an unwelcome
> alternative to free drivers, although it's actually used for reverse
> engineering and it allows to check that the unsupported hardware is
> functional without having to boot to a non-free OS.  A kernel that did
> something unsupportable becomes "tainted".
> 
> Unfortunately, the code for making ndiswrapper taint the kernel is
> similar to the code that makes non-free modules (i.e. non-free software
> specifically designed to work with Linux) taint the kernel.  That's why
> is has happened for the second time already that ndiswrapper was lumped
> together with non-free modules and disallowed to use certain kernel
> facilities that were only meant for free software.
> 
> Even though it was done by mistake both times, it looked as an
> intentional change every time.  It is an emotional issue, but it has
> little to do with copyright issues and more with understandable
> antipathy of the kernel developer towards non-free software running with
> the kernel privileges.
> 
> I think the whole idea to bring you into the discussion was based on
> misunderstanding of my use of the word "linking".  There is a difference
> between compiling and linking a non-free program from the source code
> against free headers and free libraries and loading non-free code and
> making it work by emulating non-free interfaces with free software.
> 
> I was merely saying that the later is OK.  I was not advocating the
> former.
>...

The Linux kernel is licenced under the GPLv2.

Ndiswrapper loads and executes code with not GPLv2 compatible licences 
in a way in the kernel that might be considered similar to a GPLv2'ed 
userspace program dlopen() a dynamic library file with a not GPLv2 
compatible licence.

IANAL, but I do think there might be real copyright issues with 
ndiswrapper.

> Regards,
> Pavel Roskin

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

