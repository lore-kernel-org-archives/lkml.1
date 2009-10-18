Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZJRQh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZJRQh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 12:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZJRQh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 12:37:28 -0400
Received: from norkia.v3.sk ([92.240.234.41]:33423 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbZJRQh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 12:37:27 -0400
Subject: Re: [PATCH] [snd-usb-audio] Add match for JMTek USB sound	card
From: Lubomir Rintel <lkundrak@v3.sk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Clemens Ladisch <clemens@ladisch.de>, alsa-devel@alsa-project.org,
       linux-sound@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <s5hocoddofb.wl%tiwai@suse.de>
References: <1255173329-20485-1-git-send-email-lkundrak@v3.sk>
	 <4AD2D0C2.40307@ladisch.de> <s5hzl7xdqrn.wl%tiwai@suse.de>
	 <1255334633.3286.4376.camel@localhost.localdomain>
	 <s5hocoddofb.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Oct 2009 18:37:28 +0200
Message-Id: <1255883848.2313.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 10:08 +0200, Takashi Iwai wrote:
> At Mon, 12 Oct 2009 10:03:53 +0200,
> Lubomir Rintel wrote:
> > 
> > On Mon, 2009-10-12 at 09:18 +0200, Takashi Iwai wrote:
> > > At Mon, 12 Oct 2009 08:46:26 +0200,
> > > Clemens Ladisch wrote:
> > > > 
> > > > Lubomir Rintel wrote:
> > > > > Entry for JMTek LLC., SSS USB Headphone Set in the quirk table.
> > > > 
> > > > Please add an explaination why this entry is needed.  At first glance,
> > > > this entry seems to describe a class-compliant device that should not
> > > > need a quirk.
> > > 
> > > Ah right.  It'd really helpful if Lubomir can give more details...
> > 
> > A 2.6.31.1-based kernel on my Fedora 12 workstation at hone seemed to
> > require that, only the input driver attached to the device when plugged
> > in, the snd-usb-audio didn't seem to load and did not care about the
> > device when loaded manually. I did not have an idea why, since "alias:
> > usb:v*p*d*dc*dsc*dp*ic01isc01ip*" really seemed to match my device.
> > Nevertheless, after finding out that adding an entry to the quirk table
> > solves my problem I concluded that my understanding (or lack of thereof)
> > was wrong and that alias is really not meant to match my device.
> > 
> > Now I plugged the adapter into my work lappy with 2.6.30.8-based Fedora
> > 11 and the audio interfaces on my adapter got instantly recognized and
> > claimed by snd-usb-audio (and the input interface by the input
> > subsystem), without modifying anything.
> > 
> > Any clues what could have gone wrong then?
> 
> Hm, I don't see any affecting changes between 2.6.30 and 31.
> Just as a test, could you copy sound/usb/*.[ch] from 2.6.30 tree to
> 2.6.31 or 32-rc and check whether the same problem appears?

I did not try that, but updated to a newer snapshot and it works as it
used to again, so I don't thing there's much point in finding out what
went wrong now. I'm very sorry for the noise.

Regards,
Lubo

-- 
"Excuse all the blood" -- Dead

