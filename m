Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbZGTT3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbZGTT3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbZGTT3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:29:44 -0400
Received: from [83.142.198.206] ([83.142.198.206]:47023 "EHLO
	orbiter.attika.ath.cx" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbZGTT3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:29:42 -0400
X-Greylist: delayed 1937 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 15:29:41 EDT
Date: Mon, 20 Jul 2009 20:57:21 +0200
From: Piotr Kaczuba <pepe@attika.ath.cx>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ALSA] emu10k1: hw_ptr skipping when unpausing mplayer
Message-ID: <20090720185721.GA7540@attika.ath.cx>
References: <h3srvb$71b$1@ger.gmane.org>
 <s5hab2zc18e.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hab2zc18e.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 08:33:37AM +0200, Takashi Iwai wrote:
> At Sat, 18 Jul 2009 16:07:07 +0000 (UTC),
> Piotr Kaczuba wrote:
> > 
> > Since 2.6.30 I'm experiencing sound and video stuttering when unpausing 
> > mplayer. The soundcard is an Audigy 1, driver is emu10k1. Kernel is 
> > x86_64, userspace is 32-bit. I doesn't happen always, but regularly 
> > enough.
> 
> To be sure -- isn't it arch-independent?  I guess 64bit user-space
> can cause the same problem.
I've tested it and it's the same with 64bit mplayer.

[...]
> The problem is likely due to some wrong operation in the pause/restart.
> Does the patch below work around a problem?
> 
> If this works (somehow, not causing the same error), we can focus more
> on the pause implementation of emu10k1.
[...]

Yes, the patch helps. I've tried half a dozen times and the problem
hasn't reappeared. No messages at all with xrun_debug either. So it
is probably the pause implementation of emu10k1.

Thanks,
Piotr
