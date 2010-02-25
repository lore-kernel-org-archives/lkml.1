Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934217Ab0BYVoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:44:25 -0500
Received: from toccata.ens-lyon.fr ([140.77.166.68]:44460 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933970Ab0BYVoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:44:07 -0500
Date: Thu, 25 Feb 2010 22:44:03 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, mgarski@post.pl,
       linux-input@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] Route kbd leds through the generic leds layer (3rd version)
Message-ID: <20100225214403.GB9378@const.homenet.telecomitalia.it>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
	mgarski@post.pl, linux-input@vger.kernel.org,
	Vojtech Pavlik <vojtech@suse.cz>,
	Richard Purdie <rpurdie@rpsys.net>
References: <20100224012010.GA4062@const> <20100225013840.GA5519@const.homenet.telecomitalia.it> <20100225102056.GG10823@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100225102056.GG10823@core.coreip.homeip.net>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov, le Thu 25 Feb 2010 02:20:56 -0800, a écrit :
> I am aunsure about this patch. It ties all LEDs together

For now, yes.  There could be an additional per-device layer that the
user could select instead, but my patch doesn't prevent that.

> whereas currently it is possible to operate keyboards and their leds
> independently

You mean through the input layer?  Technically, yes, but at least my
patch is an improvement over what exists right now: at first read of
your sentence I thought "of course not! keyboard.c does it for all
devices!", so it's not a regression in that concern.  On the contrary,
it fixes the problem of proper caps lock with led feedback.

Being able to assign only some of the devices to the linux console
would indeed probably be good, but to me it's just a refinement. Users
a priori assume all keyboards get their leds updated, so my patch
makes sense.  And it won't prevent a further patch that, in addition
to input::<led> leds, adds per-device leds, which the user could use
instead of input::<led>.

Samuel
