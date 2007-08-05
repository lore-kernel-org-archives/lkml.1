Return-Path: <linux-kernel-owner+w=401wt.eu-S932737AbXHEDLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbXHEDLn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 23:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbXHEDLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 23:11:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60408 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbXHEDLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 23:11:33 -0400
Message-ID: <46B53FDF.5020806@zytor.com>
Date: Sat, 04 Aug 2007 20:11:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: Linux 2.6.23-rc2
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>	 <b6a2187b0708032213r476204fbh917d3d6672c70528@mail.gmail.com>	 <b6a2187b0708032234r6ad41be4u5d8142b0b199fcc1@mail.gmail.com>	 <b6a2187b0708040652l28e9d5aal2cc898f8006906f2@mail.gmail.com>	 <alpine.LFD.0.999.0708040900170.5037@woody.linux-foundation.org>	 <46B4C011.8090802@zytor.com> <b6a2187b0708041937u41f3911ap3f1af6115b797d6b@mail.gmail.com>
In-Reply-To: <b6a2187b0708041937u41f3911ap3f1af6115b797d6b@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> On 8/5/07, H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> Also, can you please describe "messed up" in more detail?
> 
> The screen went into some graphic mode that can't be reset no matter
> what I tried (stty reset). I see all kinds of ramdom pattern/color
> everywhere. Then typing "startx" would get in X just fine. But trying
> to get back to console (ALT F1) or (Ctrl ALT BackSpace) would still
> end up with the messed-up console.
> 

>> Are you using the VGA console or a framebuffer console?
>
> VGA console.

Okay, since you're using VGA console this means suspend-to-ram isn't
restoring the mode.

Does it matter if you suspend from inside X or not?

>> We had one report of "screen messed up" already that did get fixed
>> (CONFIG_FIRMWARE_EDID not working.)
> 
> How can I try this?

The patch for this is in -rc2.

	-hpa
