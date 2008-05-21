Return-Path: <linux-kernel-owner+w=401wt.eu-S1763935AbYEUW0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763935AbYEUW0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbYEUW0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:26:14 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58007 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbYEUW0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:26:13 -0400
Date: Thu, 22 May 2008 01:23:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       alsa-devel@alsa-project.org, perex@perex.cz
Subject: Re: Moving sound/* to drivers/ ?
Message-ID: <20080521222357.GB16376@cs181133002.pp.htv.fi>
References: <s5hzlqjz74d.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <s5hzlqjz74d.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 11:20:50PM +0200, Takashi Iwai wrote:
> While we are at the issue ALSA HG <-> GIT transition...
> 
> One thing that annoys me sometimes is that the sound driver codes are
> on a different subdirectory than other normal drivers, namely under
> /sound.   I don't remember exactly why it came there, but this often
> makes people forget to change the necessary code for the sound
> subsystem, or slip from the statistics (I'm not sure whether Linus
> counted sound/* with recent his posts).
> 
> If I understand correctly, with git, we can move the files in
> relatively little costs.  So, what about moving sound/* back to
> drivers/sound/* or drivers/media/sound/*?

Sounds good.

> Of course, the primary question is whether it's really worth.
> The obvious drawback is that patches won't be applicable after the
> move.  So, if we do it, doing at the last seems practical.  But, this
> can be a bit problem with keeping such a change on linux-next until
> the next merge...
> 
> And, another question is to where.  drivers/sound or
> drivers/media/sound, or whatever.

Under drivers/media/ it would only generate confusion regarding who's 
responsible for what.

But drivers/sound/ sounds good.

The only possible problem that comes into my mind is to check what 
happens with the link order.

> Any comments appreciated.
> 
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

