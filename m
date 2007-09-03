Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbXICUXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbXICUXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 16:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbXICUXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 16:23:15 -0400
Received: from www17.your-server.de ([213.133.104.17]:50419 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbXICUXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 16:23:14 -0400
Message-ID: <46DC6D2A.9070306@m3y3r.de>
Date: Mon, 03 Sep 2007 22:23:06 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "Ivan N. Zlatev" <contact@i-nz.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2/4] 2.6.23-rc4: known regressions
References: <46D58CC6.4020605@googlemail.com>	<46D59052.6040609@googlemail.com>	<3db1ec7f0708290842y176c48eck9f39131a107756f9@mail.gmail.com> <s5hodgqibf8.wl%tiwai@suse.de>
In-Reply-To: <s5hodgqibf8.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai schrieb:
> At Wed, 29 Aug 2007 18:42:56 +0300,
> Ivan N. Zlatev wrote:
>   
> ... but without the hardware :-<
>
> IMO, this is actually no real regression.  In the earlier verison, you
> didn't have controls for multiple outputs, thus the mixer control was
> named as Master.  Now you do have multiple individual controls, and
> thus there is no master any more, instead.  That's the trade-off.
>   
Konnichiwa.

Ok. Seen from this viewpoint this is no real regression. But do you have
an idea how can i fix my setup?

Currently i have these .Xmodmap key bindings:

keycode 174 = XF86AudioLowerVolume
keycode 176 = XF86AudioRaiseVolume
keycode 160 = XF86AudioMute

Some kde component while take care of the "XF86AudioLowerVolume" and
"XF86AudioRaiseVolume" events and change the value of the "master"
volume control.

This is still happening with 2.6.23-rc5, but the master volume, stopped to be connected with the build-in speakers.
When i connect headphones to my notebook the "MacBook-Volume-Up" and "MacBook-Volume-Down" keys still work, but they stopped to work with the build-in speaker, but will work with the headphones plugged in.

The problem is, that i use the build-in speakers more often than the headphones.
When a headphone is connected the build-in speakers go silent.

And i agree with Mr. Juhl that a master volume control should control both outputs, i.e. built-in speakers and headphones.

Any ideas?

mfg
thomas


