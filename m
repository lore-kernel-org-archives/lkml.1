Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbZKAXTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbZKAXTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 18:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZKAXTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 18:19:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40119 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZKAXTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 18:19:52 -0500
Date: Mon, 2 Nov 2009 00:19:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [3/3,ARM] msm: add minimal board file for HTC Dream device
Message-ID: <20091101231950.GF20740@elf.ucw.cz>
References: <20091101221345.GA16926@elf.ucw.cz>
 <a55d774e0911011501x6abdb6a2p117f7038a4fa80cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a55d774e0911011501x6abdb6a2p117f7038a4fa80cf@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-11-01 15:01:19, Brian Swetland wrote:
> On Sun, Nov 1, 2009 at 2:13 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> > On Thu 2009-06-18 00:31:15, Brian Swetland wrote:
> >> This is just enough to get the device booting and serial console
> >> working.  Sufficient for debugging further MSM7k/Dream Support.
> >> This will support HTC Dream / T-Mobile G1 / Android ADP1 (which
> >> are all the same hardware, known as "trout" to the ARM machine
> >> database).
> >>
> >> Signed-off-by: Brian Swetland <swetland@google.com>
> >> Acked-by: Pavel Machek <pavel@ucw.cz>
> >> Reviewed-by: GeunSik Lim <geunsik.lim@samsung.com>
> >
> > I'm trying to get this series to work -- i.e. get dream boot up-to
> > serial console.
> >
> > I tried applying series on 2.6.29, and it failed compilation.
> >
> > On 2.6.30 and 2.6.32-rc, I get "Uncompressing linux..." feedback on
> > serial, but that's it. Do you still remember what kernel version these
> > should be applied to? .config would be helpful, too...
> 
> Pretty sure it's something later than .29

I guess I should try 2.6.31.

> Does enabling DEBUG_LL help?  If something's dying before the serial
> port is registered, you might never see any console chatter.

DEBUG_LL does not help. Is that early_printk() equivalent? 
With DEBUG_ICEDC I don't even get "uncompressing linux" message.

Yes, I believe it dies before serial registration :-(. Being able to
call puts() that decompressor uses would be useful...

> Also, I believe you'll want to pass console=ttyMSM2,115200n8 on the
> kernel commandline  (-c parameter to fastboot or mkbootimg).

I'm using "console=ttyMSM2 rootdelay=5 fbcon=rotate:1" that worked for
me on another kernel version...

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
