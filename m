Return-Path: <linux-kernel-owner+w=401wt.eu-S1750732AbXBSIEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750732AbXBSIEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 03:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbXBSIEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 03:04:44 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44727 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbXBSIEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 03:04:44 -0500
Date: Mon, 19 Feb 2007 00:04:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yaroslav Halchenko <kernel@onerussian.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
Message-Id: <20070219000412.acad13de.akpm@linux-foundation.org>
In-Reply-To: <20070219044616.GC25659@washoe.onerussian.com>
References: <20070219044616.GC25659@washoe.onerussian.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Feb 2007 23:46:16 -0500 Yaroslav Halchenko <kernel@onerussian.com> wrote:

> Dear Kernel Developers,
> 
> Since the most recent successful for me kernel 2.6.19-rc6-mm1, I've
> tried few times to build more recent snapshots and now finally
> 2.6.20-mm2. In all those cases I have a sad outcome -- kernel boots but
> at some point during boot (few moments after Penguin icon in the top left
> corner appears), light turns off... I still can see something, especially
> if I light a strong flashlight at a sharp angle.
> 
> I've enabled back-light support and lcd support for those unsuccessful
> kernels (with all backlight support features disabled kernel boots
> ok and backlight shines as bright as always)
> 
> All my changes of values for files under
> /sys/class/backlight/radeonbl0
> had no impact on the screen. Also I had no files under /sys/class/lcd.
> 
> Running 
> radeontool light off
> caused complete turning off of LCD - I could not see
> anything anymore.
> 
> sony's spictl -b had no effect as well.
> 
> Config can be found at
> http://www.onerussian.com/Linux/bugs/nobacklight.1/config-2.6.20-mm2
> lshw
> http://www.onerussian.com/Linux/bugs/nobacklight.1/lshw
> other details are available from
> http://www.onerussian.com/Linux/bugs/nobacklight.1/
> 
> Could you please advise?

(cc's added)

Is 2.6.20 broken?  I assume the latest 2.6.20-gitN snapshot are failing..
