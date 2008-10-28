Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYJ1Vnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYJ1Vnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbYJ1VnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:43:09 -0400
Received: from smtp3.Stanford.EDU ([171.67.20.26]:38849 "EHLO
	smtp3.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYJ1VnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:43:07 -0400
Subject: Re: [alsa-devel] 2.6.26.[6|7] vs. rt11 vs. alsa (usb) midi
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Fernando Pablo Lopez-Lezcano <nando@ccrma.Stanford.EDU>
In-Reply-To: <s5hljwazc9i.wl%tiwai@suse.de>
References: <1224989187.3706.7.camel@localhost.localdomain>
	 <s5hljwazc9i.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 14:35:55 -0700
Message-Id: <1225229755.3750.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 09:13 +0100, Takashi Iwai wrote:
> At Sat, 25 Oct 2008 19:46:27 -0700,
> Fernando Lopez-Lezcano wrote:
> > 
> > Hi... anyone out there also having problem with this combination?
> >    2.6.26.7 or 2.6.26.6 with 2.6.26.6-rt11 and alsa MIDI
> > It looks to me like alsa midi is broken. 
> > 
> > Probably an interaction with the realtime kernel patch. A Fedora kernel
> > based on 2.6.26.6 (2.6.26.6-49 on fc8) works fine, a very similarly
> > patched kernel that includes the realtime patch does not. The
> > configurations for both are almost the same (today I tried to change
> > some of the most obvious differences and rebuild, with the same
> > result). 
> > 
> > No problems with 2.6.24.7-rt21. 
> > 
> > Test: boot, login, plugin an external usb keyboard (Yamaha P250), it is
> > recognized, use qjackctl alsa patchbay to connect it to kmidimon,
> > kmidimon sees only _one_ midi message and that's it. Kmidimon can't be
> > killed after that. 
> 
> What about other MIDI devices on other bus, e.g. an MPU401 on a PCI
> soundcard or so?  There is a possibility of breakage in the USB driver
> side, too.

I just tested an RME PCMCIA card + Multiface interface and it shows the
same problem. No MIDI messages get through (but the LED in the Multiface
blinks). Same hardware booted into 2.6.24.7-rt21 works fine. 

-- Fernando


