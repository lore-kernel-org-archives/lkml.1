Return-Path: <linux-kernel-owner+w=401wt.eu-S1765368AbXHDSGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765368AbXHDSGY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764947AbXHDSGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:06:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42797 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbXHDSGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:06:16 -0400
Message-ID: <46B4C011.8090802@zytor.com>
Date: Sat, 04 Aug 2007 11:06:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeff Chua <jeff.chua.linux@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: Linux 2.6.23-rc2
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>  <b6a2187b0708032213r476204fbh917d3d6672c70528@mail.gmail.com>  <b6a2187b0708032234r6ad41be4u5d8142b0b199fcc1@mail.gmail.com> <b6a2187b0708040652l28e9d5aal2cc898f8006906f2@mail.gmail.com> <alpine.LFD.0.999.0708040900170.5037@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708040900170.5037@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 4 Aug 2007, Jeff Chua wrote:
>> On 8/4/07, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>>>> After resume from s2ram or switching to console from X, my console is
>>>> messed up on rc1 and rc2. Is there a fix for this?
>>> This is on IBM X60. i915 chipset. No problem on 2.6.22. If this is a
>>> known problem, than I don't need to bisect all over again.
>> I managed to bisect down to this commit. Without this, console screen
>> can resume without video mess.
> 
> [ The commit being 4fd06960f120e02e9abc802a09f9511c400042a5: "Use the new 
>   x86 setup code for i386" ]
> 
> Very interesting. 
> 
> Jeff - do I understand correctly that the "or" means that even *without* a 
> suspend-to-ram sequence, and just by going into X and then going back to 
> text-mode, the screen is corrupt?

Also, can you please describe "messed up" in more detail?  We had one
report of "screen messed up" already that did get fixed
(CONFIG_FIRMWARE_EDID not working.)

Are you using the VGA console or a framebuffer console?

Also, please submit your .config and kernel command line.

	-=hpa
