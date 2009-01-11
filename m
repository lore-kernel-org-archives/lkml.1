Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbZAKRqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbZAKRqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 12:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZAKRqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 12:46:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33526 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbZAKRqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 12:46:01 -0500
Date: Sun, 11 Jan 2009 19:00:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: usb alsa oops in 2.6.28 in snd_mixer_oss_notify_handler
Message-ID: <20090111180020.GK26290@one.firstfloor.org>
References: <20090109182653.GA12123@basil.nowhere.org> <s5hmydy2gk7.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hmydy2gk7.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 01:06:00PM +0100, Takashi Iwai wrote:
> At Fri, 9 Jan 2009 19:26:53 +0100,
> Andi Kleen wrote:
> > 
> > 
> > Just got this oops in ALSA with 2.6.28 when I pulled a usb 
> > sound device while something was writing to it.
> > It looks like it jumped to Nirvana through a bad function
> > pointer.
> 
> Bah, this is a die-hard bug.
> 
> What kind of apps and sound-subsystem were you running while it's
> disconnected?

Just mpg321 playing (that's also what crashed), nothing more (no sound server
or similar) 

The system has two sound outputs, one motherboard snd_hda and
a usb headset. The output was on the USB headset in this case
which I pulled out.

-Andi


-- 
ak@linux.intel.com
