Return-Path: <linux-kernel-owner+w=401wt.eu-S1759722AbYEEOYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722AbYEEOYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbYEEOYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:24:07 -0400
Received: from mail.skyusermail.com ([77.240.11.49]:1351 "EHLO
	mail.skyusermail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039AbYEEOYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:24:05 -0400
X-Greylist: delayed 1816 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 May 2008 10:24:05 EDT
Subject: Re: 2.6.26-rc1-git1 -- trying to get vblank count for disabled
	pipe 0
From: Steven J Newbury <steve@snewbury.org.uk>
To: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@tungstengraphics.com>
Cc: Miles Lane <miles.lane@gmail.com>, David Airlie <airlied@linux.ie>,
       DRI for Linux <dri-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1209975302.26326.263.camel@thor.sulgenrain.local>
References: <481E5EE6.6090503@gmail.com>
	 <1209975302.26326.263.camel@thor.sulgenrain.local>
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 05 May 2008 13:51:56 +0100
Message-Id: <1209991916.24777.8.camel@infinity>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-05 at 10:15 +0200, Michel Dänzer wrote:
> On Sun, 2008-05-04 at 21:12 -0400, Miles Lane wrote:
> > When I boot this kernel, everything seems okay, but after I leave the
> > machine for 30 minutes or so, I come back and find the machine locked
> > up.  
> 
> Define 'locked up'. Can you ping it? Can you log in via ssh? Is the X
> server still alive? Where is it stuck? ...
> 
> 
> > When I checked my log file after rebooting, I find the log filled with "trying to get vblank count for disabled pipe 0".
> 
> [...]
> 
> > May  4 14:40:44 whirligig kernel: [   47.544109] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x12, stream=0x5, channel=0, format=0x4011
> > May  4 14:40:46 whirligig kernel: [   48.850489] trying to get vblank count for disabled pipe 0
> > May  4 14:40:46 whirligig kernel: [   48.897990] trying to get vblank count for disabled pipe 0
> > May  4 14:40:46 whirligig kernel: [   48.941691] trying to get vblank count for disabled pipe 0
> > May  4 14:40:46 whirligig kernel: [   49.003556] trying to get vblank count for disabled pipe 0
> > May  4 14:40:46 whirligig kernel: [   49.147880] trying to get vblank count for disabled pipe 0
> > May  4 14:40:47 whirligig kernel: [   50.528654] trying to get vblank count for disabled pipe 0
> > [...]
> > May  4 15:36:23 whirligig kernel: [ 3404.847515] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0xe
> > May  4 16:06:53 whirligig kernel: [ 5241.488711] trying to get vblank count for disabled pipe 1
> > May  4 16:06:53 whirligig kernel: [ 5241.488748] trying to get vblank count for disabled pipe 1
> > May  4 16:06:53 whirligig kernel: [ 5241.496130] trying to get vblank count for disabled pipe 1
> > May  4 16:06:53 whirligig kernel: [ 5241.516053] trying to get vblank
> > count for disabled pipe 1
> 
> Note that some of these are for pipe 1 as well as pipe 0. Does the
> problem only occur for one of them?
Miles isn't alone, I also get 'trying to get vblank count for disabled
pipe 0' (GM965).  vblank interrupts were previously not working for me,
but they are now.  I'm not sure what's changed. 
> 
> Do you have any GL apps running when this happens?
> 
For me, this happens every time a GL app is run.

I'm also getting occasional lockups.  Often it's the window manager
(metacity) that locks up when attempting to move a window, restarting
the window manager unlocks X but attempting to move a window again
results in another lockup.  When it's locked up the pointer moves and vt
switching works but nothing else.  Other times I've had a hard lockup
that required a hard reboot, this happens less frequently.

