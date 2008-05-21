Return-Path: <linux-kernel-owner+w=401wt.eu-S936917AbYEUVzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936917AbYEUVzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759159AbYEUVzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:55:42 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:56882 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758835AbYEUVzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:55:41 -0400
Message-ID: <48349AF2.30009@keyaccess.nl>
Date: Wed, 21 May 2008 23:58:10 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] Moving sound/* to drivers/ ?
References: <s5hzlqjz74d.wl%tiwai@suse.de> <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-05-08 23:44, Linus Torvalds wrote:

> So I would personally certainly not mind somebody doing a 
> 
> 	git mv sound drivers/sound
> 	.. edit makefiles and Kconfig files appropriately ..
> 	git commit -a
> 
> and it wouldn't be a problem for git (ie the repository wouldn't grow or 
> anything like that).

I'd personally like the net/ structure more. So subsystem code under 
sound/ and drivers moved to drivers/sound/.

>> Of course, the primary question is whether it's really worth.
>> The obvious drawback is that patches won't be applicable after the
>> move.
> 
> Well, git merging is actually pretty good at this, so you can apply the 
> patches to the old release and then merge it, and it will do the right 
> thing (perhaps not for newly created files, but that's pretty easy to fix 
> up).

And a few symlinks will do wonders as well. I do/did that when I "port" 
patches developped against mainline to the alsa-kernel HG repo. Not a 
problem that way. Apply and rediff to get the new paths.

> Me personally, I've been more irritated by include/asm-xyz vs arch/xyz. It 
> would be so nice if all the arch-specific changes woudl always show up 
> under arch/ (both from a statistics standpoint, and just because then a 
> diffstat really shows arch-specific stuff really obviously, and sorts all 
> the arch-specific stuff together).

And one would not forget to add the include directory to a "git log" or 
"git bisect" path specification...

Rene.
