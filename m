Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab0BLJYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 04:24:11 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34712 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346Ab0BLJYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 04:24:08 -0500
X-Sasl-enc: 0WDcHoz7VF4/e4JicmBdw6sTm22sh0+DVYc4V63corJ4 1265966646
Message-ID: <4B751E34.1000703@ladisch.de>
Date: Fri, 12 Feb 2010 10:24:04 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Sebastien Alaiwan <sebastien.alaiwan@gmail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH][ALSA] usbmidi support for Access Music synths.
References: <4B726306.8070506@gmail.com> <4B7274BA.3040801@ladisch.de> <4B73B96A.9040006@gmail.com> <4B73C3EC.2040606@ladisch.de> <4B745D00.5060201@gmail.com>
In-Reply-To: <4B745D00.5060201@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastien Alaiwan wrote:
> I've replaced the QUIRK_COMPOSITE by a QUIRK_MIDI_FIXED_ENDPOINT, the
> module also probes (and fails) the USB interface 4 (I don't know
> what this interface is for on this device) which results in the
> printing of an error in the kernel log. How can I inform the
> snd-usb-audio driver that the USB interface 4 should be left alone?

With a QUIRK_IGNORE_INTERFACE for that interface.  This means you need
QUIRK_COMPOSITE again.


HTH
Clemens
