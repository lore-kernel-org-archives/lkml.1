Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbZF2MrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbZF2MrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbZF2MrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:47:08 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:49914 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736AbZF2MrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:47:07 -0400
From: Frans Pop <elendil@planet.nl>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: PC speaker beeps in 2.6.30?
Date: Mon, 29 Jun 2009 14:47:06 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       alsa-devel@vger.kernel.org
References: <4A365DA6.8000102@msgid.tls.msk.ru> <4A365DA6.8000102@msgid.tls.msk.ru> <4A4464CA.4060006@msgid.tls.msk.ru>
In-reply-To: <4A4464CA.4060006@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906291447.08249.elendil@planet.nl>
X-OriginalArrivalTime: 29 Jun 2009 12:47:09.0173 (UTC) FILETIME=[B71EEA50:01C9F8B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Am I the only concerned about this?  My 2.6.30 is still
> silent w.r.t. old good PC speaker beeps, and I wasn't
> able to make it to produce any sound.  Yes, as pointed
> out by others there is a control now, in alsa,

Did you actually try compiling a kernel without CONFIG_SND_HDA_INPUT_BEEP 
set? If you do, does your PC speaker work again?

If it does work again, I don't think there is a bug, at least not in the 
fact that the old PC speaker beep no longer works: if you have a HDA 
soundcard in the system _and_ the driver is loaded _and_ 
CONFIG_SND_HDA_INPUT_BEEP is set, then it seems logical to me that that 
takes over system beeps.
The fact that the config option also existed in 2.6.29 but did not work 
the same seems a minor issue to me.

If your PC speaker still does not work when CONFIG_SND_HDA_INPUT_BEEP is 
not set, then there is something to look into.

> and I can hear ugly and scary beeps from my stereo speakers
> (when they're turned on and when the control is un-muted).

This may be a separate issue. On my system the beep sounds "normal". It 
has been changed in 2.6.31-rc1 to a slightly lower sound.

What exactly do you mean by "ugly and scary"? I have the volume for the 
beep set to about 50% because otherwise it is just too loud. Have you 
tried that?

If it really does sound bad, maybe the ALSA developers could look into 
that, but you will have to describe it better (or maybe make a 
recording?).

Cheers,
FJP
