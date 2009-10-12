Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbZJLIiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbZJLIiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbZJLIiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:38:09 -0400
Received: from norkia.v3.sk ([92.240.234.41]:34403 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbZJLIiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:38:08 -0400
X-Greylist: delayed 2017 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2009 04:38:08 EDT
Subject: Re: [PATCH] [snd-usb-audio] Add match for JMTek USB sound	card
From: Lubomir Rintel <lkundrak@v3.sk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Clemens Ladisch <clemens@ladisch.de>, alsa-devel@alsa-project.org,
       linux-sound@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <s5hzl7xdqrn.wl%tiwai@suse.de>
References: <1255173329-20485-1-git-send-email-lkundrak@v3.sk>
	 <4AD2D0C2.40307@ladisch.de>  <s5hzl7xdqrn.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Mon, 12 Oct 2009 10:03:53 +0200
Message-Id: <1255334633.3286.4376.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 09:18 +0200, Takashi Iwai wrote:
> At Mon, 12 Oct 2009 08:46:26 +0200,
> Clemens Ladisch wrote:
> > 
> > Lubomir Rintel wrote:
> > > Entry for JMTek LLC., SSS USB Headphone Set in the quirk table.
> > 
> > Please add an explaination why this entry is needed.  At first glance,
> > this entry seems to describe a class-compliant device that should not
> > need a quirk.
> 
> Ah right.  It'd really helpful if Lubomir can give more details...

A 2.6.31.1-based kernel on my Fedora 12 workstation at hone seemed to
require that, only the input driver attached to the device when plugged
in, the snd-usb-audio didn't seem to load and did not care about the
device when loaded manually. I did not have an idea why, since "alias:
usb:v*p*d*dc*dsc*dp*ic01isc01ip*" really seemed to match my device.
Nevertheless, after finding out that adding an entry to the quirk table
solves my problem I concluded that my understanding (or lack of thereof)
was wrong and that alias is really not meant to match my device.

Now I plugged the adapter into my work lappy with 2.6.30.8-based Fedora
11 and the audio interfaces on my adapter got instantly recognized and
claimed by snd-usb-audio (and the input interface by the input
subsystem), without modifying anything.

Any clues what could have gone wrong then?

-- 
Flash is the Web2.0 version of blink and animated gifs.
                                     -- Stephen Smoogen

