Return-Path: <linux-kernel-owner+w=401wt.eu-S2993312AbXDTSSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993312AbXDTSSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993313AbXDTSSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:18:34 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993312AbXDTSSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:18:33 -0400
Date: Fri, 20 Apr 2007 11:18:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       perex@suse.cz, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [1/2] 2.6.21-rc7: known regressions
Message-Id: <20070420111807.82d67afb.akpm@linux-foundation.org>
In-Reply-To: <s5h7is7xrkl.wl%tiwai@suse.de>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
	<20070416003714.GL3691@stusta.de>
	<4623EE59.7090005@redhat.com>
	<s5hk5wbcny7.wl%tiwai@suse.de>
	<4627CB04.4060401@googlemail.com>
	<s5h7is7xrkl.wl%tiwai@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 12:34:18 +0200
Takashi Iwai <tiwai@suse.de> wrote:

> Good to hear!  I forgot the patch description and sign-off, so here it
> is again:
> 
> 
> [PATCH] ALSA: intel8x0 - Fix Oops in crash kernel
> 
> When intel8x0 driver is loaded in the crash kernel, it gets Oops
> occasionally.  This is because the irq handler gets called before
> the proper hardware initialization.  Now defer it after
> snd_intel8x0_chip_init().

Neat, thanks.

Do we think this is safe enough and important enough for 2.6.21?
And if so, do you want me to merge it?
