Return-Path: <linux-kernel-owner+w=401wt.eu-S1762678AbYD3Las@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678AbYD3Las (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762287AbYD3Lac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:30:32 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38569 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762080AbYD3LaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:30:25 -0400
Date: Wed, 30 Apr 2008 13:29:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: tiwai@suse.de, mingo@elte.hu, mchehab@infradead.org,
       akpm@linux-foundation.org, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       efault@gmx.de
Subject: Re: [patch, -git] media/video/sound build fix, TEA5761/TEA5767
Message-ID: <20080430112959.GA32556@uranus.ravnborg.org>
References: <20080430110115.GA5633@elte.hu> <s5hiqxzwqak.wl%tiwai@suse.de> <20080430.041703.89847530.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430.041703.89847530.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 04:17:03AM -0700, David Miller wrote:
> From: Takashi Iwai <tiwai@suse.de>
> Date: Wed, 30 Apr 2008 13:11:31 +0200
> 
> > IMO, it's the reverse selection from sound to V4L that makes things
> > complicated.  I believe it's better to fix it as a normal dependency.
> > 
> > How about the patch below?
> 
> The question that remains is what does this mean for users?
> 
> How does a user, who wants to enable this 'sound' driver,
> learn that they must enable the v4l subsystem in order to
> do so?

[OT to the actual problem]

I have envisioned something like a "requires tag" that
would list what a config symbols needs.

Like in this case it would have been:

	requires V4L

This should in the frontends then if the user selects a symbol
where the 'requires' are not satisfied with a window listing
the menuentries for the symbol that the user needs to
enable to satisfy what the original symbol requires.

This is the only way to do this in a way so the
user is actually aware that enabling a webcam also enables USB.
Or at least this is my best suggestion.

But sorry - I have not implemented it.
And it is likely more complicated than I foresee.

	Sam
