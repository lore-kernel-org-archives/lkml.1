Return-Path: <linux-kernel-owner+w=401wt.eu-S1762228AbXJREYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762228AbXJREYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 00:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbXJREYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 00:24:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44690 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbXJREYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 00:24:41 -0400
Message-ID: <4716E006.4040609@garzik.org>
Date: Thu, 18 Oct 2007 00:24:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Thomas Meyer <thomas@m3y3r.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: hda-intel: no soundcard with current linus' git tree
References: <471538C2.80806@m3y3r.de> <200710180536.18611.maximlevitsky@gmail.com> <4716D51E.2010509@garzik.org> <200710180610.13051.maximlevitsky@gmail.com>
In-Reply-To: <200710180610.13051.maximlevitsky@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> Probably everything is fine.
> 
> I added a new mixer control called "Master Volume"
> it is a VolumeKnob.
> 
> It is a hardware control, that was unused in the driver before.
> 
> It affects the volume of all DACs
> check if it is enabled, and set to maximum value.
> 
> This control affects the volume quite a lot, for example on my system
> if I set it to middle, I almost hear no sound.
> 
> Maybe something else unrelated to my patches broke your sound too.


'alsamixergui' shows it enabled, and near the maximum.

I'll bisect this no-audio regression when I have time, but that will be 
after I'm finished with the current libata explosions :(

In the meantime, feel free to ask for more diagnostic output.

	Jeff


