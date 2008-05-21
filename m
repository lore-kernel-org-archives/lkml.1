Return-Path: <linux-kernel-owner+w=401wt.eu-S932631AbYEUXiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbYEUXiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759532AbYEUXh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:37:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57019 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758991AbYEUXh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:37:59 -0400
Message-ID: <4834B252.1080700@garzik.org>
Date: Wed, 21 May 2008 19:37:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       alsa-devel@alsa-project.org, perex@perex.cz
Subject: Re: Moving sound/* to drivers/ ?
References: <s5hzlqjz74d.wl%tiwai@suse.de>
In-Reply-To: <s5hzlqjz74d.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
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
> 
> Of course, the primary question is whether it's really worth.
> The obvious drawback is that patches won't be applicable after the
> move.  So, if we do it, doing at the last seems practical.  But, this
> can be a bit problem with keeping such a change on linux-next until
> the next merge...
> 
> And, another question is to where.  drivers/sound or
> drivers/media/sound, or whatever.

Speaking as a former OSS driver maintainer, I always preferred 
drivers/sound.

Though Rene's suggestion (use both sound/ and drivers/sound/) might make 
sense if the subsystem code is huge -- I supported the drivers/block/ -> 
block/ code movement for example.

	Jeff




