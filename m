Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab0CGMGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 07:06:15 -0500
Received: from solo.fdn.fr ([80.67.169.19]:40893 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab0CGMGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 07:06:13 -0500
Date: Sun, 7 Mar 2010 13:06:04 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, mgarski@post.pl, linux-input@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] Route kbd leds through the generic leds layer (3rd version)
Message-ID: <20100307120604.GE5203@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
	mgarski@post.pl, linux-input@vger.kernel.org,
	Vojtech Pavlik <vojtech@suse.cz>,
	Richard Purdie <rpurdie@rpsys.net>
References: <20100224012010.GA4062@const> <20100225013840.GA5519@const.homenet.telecomitalia.it> <20100225102056.GG10823@core.coreip.homeip.net> <20100225214403.GB9378@const.homenet.telecomitalia.it> <20100226035448.GA16797@core.coreip.homeip.net> <20100226103505.GB3992@const.homenet.telecomitalia.it> <20100306065457.GE28759@elf.ucw.cz> <20100306123058.GE5203@const.famille.thibault.fr> <20100307082519.GC1987@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100307082519.GC1987@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek, le Sun 07 Mar 2010 09:25:19 +0100, a écrit :
> But you mentioned having per-keyboard led would be quite easy, it does
> not seem to be controversial, so perhaps that's way to go, first?

Thinking more about it, what about the following:

keyboard numlock trigger -> input numlock led -> input numlock trigger -> input keyboard led

Userland applications which want to redirect leds for (a priori) all
keyboards change the trigger used by the input numlock led. Userland
applications which want to redirect leds for a particular keyboard can
change the trigger user by the particular input keyboard led.

Samuel
