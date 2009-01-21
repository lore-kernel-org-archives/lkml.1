Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbZAUFkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbZAUFkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 00:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbZAUFjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 00:39:54 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:33553 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZAUFjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 00:39:53 -0500
Date: Wed, 21 Jan 2009 06:41:38 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, alsa-devel@alsa-project.org,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: usr/include/linux/soundcard.h warnings for 'make headers_check'
Message-ID: <20090121054138.GA26551@uranus.ravnborg.org>
References: <1232465902.3088.31.camel@localhost.localdomain> <s5h7i4psepm.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h7i4psepm.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 01:08:37AM +0100, Takashi Iwai wrote:
> At Tue, 20 Jan 2009 21:08:22 +0530,
> Jaswinder Singh Rajput wrote:
> > 
> > usr/include/linux/soundcard.h is giving following warnings for 'make headers_check':
> >  usr/include/linux/soundcard.h:1047: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1048: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1049: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1050: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1051: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1053: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1055: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1056: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1061: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1062: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1078: extern's make no sense in userspace
> >  usr/include/linux/soundcard.h:1079: extern's make no sense in userspace
> > 
> > Do we need to fix these warnings.
> 
> No, these are declarations for OSS-lib.
> It doesn't belong to kernel, but it's better to keep it for
> compatibility in some way.

But not in the kernel for sure.
I just checked and for example: OSS_init is not used anywhere in the kernel.
The kernel headers are not a "dump all your stuff" ground anymore.

So I encourage you to find a better home for the user space library definitons.
We can let the definiton stay for a while - but eventually they have to
be dropped from the kernel.

	Sam
