Return-Path: <linux-kernel-owner+w=401wt.eu-S1751372AbXBVANO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbXBVANO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbXBVANO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:13:14 -0500
Received: from tim.rpsys.net ([194.106.48.114]:58724 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbXBVANN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:13:13 -0500
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
From: Richard Purdie <rpurdie@rpsys.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alex Romosan <romosan@sycorax.lbl.gov>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       James Simmons <jsimmons@infradead.org>
In-Reply-To: <20070221231706.GA3336@khazad-dum.debian.net>
References: <20070219044616.GC25659@washoe.onerussian.com>
	 <20070219000412.acad13de.akpm@linux-foundation.org>
	 <1171876788.6046.3.camel@localhost.localdomain>
	 <877iub9mu2.fsf@sycorax.lbl.gov>
	 <1172097718.5790.29.camel@localhost.localdomain>
	 <20070221231706.GA3336@khazad-dum.debian.net>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 00:12:39 +0000
Message-Id: <1172103159.5790.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 21:17 -0200, Henrique de Moraes Holschuh wrote:
> On Wed, 21 Feb 2007, Richard Purdie wrote:
> > enabled. On a thinkpad, the backlight is probably under ACPI control.
> 
> BIOS+ACPI, actually.  Without ACPI video loaded, the firmware does
> everything correctly.  With ACPI video, the firmware does it, then its
> changes are clobbered over by ACPI video's.
> 
> If ibm-acpi is loaded, a backlight device "ibm" is added.  ibm-acpi's ibm
> backlight device can change the display brightness.  It is *not* capable of
> turning the backlight on or off, AFAIK.
> 
> BTW, some ThinkPads don't have a Radeon, but rather an Intel GM/GMX device.

I have a thinkpad with Intel GM graphics ;-). I need it to work so I try
not to experiment too much on it. I've just tried the ibm-acpi driver
and it doesn't work well :-(.

So far I've noticed:

* 'cat brightness' != 'cat actual_brightness' upon bootup (doesn't have
to be true if there is hardware brightness limiting or level changing in
action but that wouldn't be the case here and this could be fixed
easily).
* 'echo 0 > brightness' lowered the intensity but by a level or two, not
set it to level 0. A couple of more attempts and it did jump from 7 -> 1
and so on, it seems erratic.

actual_brightness always seems to be correct, as does brightness so it
looks like its not updating the hardware correctly.

Regards,

Richard







