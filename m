Return-Path: <linux-kernel-owner+w=401wt.eu-S1945903AbXBUXCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945903AbXBUXCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945905AbXBUXCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:02:31 -0500
Received: from max.feld.cvut.cz ([147.32.192.36]:60522 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945901AbXBUXC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:02:28 -0500
From: CIJOML <cijoml@volny.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Phis in /proc/bus/input/devices same for all devices?
Date: Thu, 22 Feb 2007 00:02:19 +0100
User-Agent: KMail/1.9.5
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
References: <200702212313.30359.cijoml@volny.cz> <200702212354.38618.cijoml@volny.cz> <1172098829.7403.58.camel@violet>
In-Reply-To: <1172098829.7403.58.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702220002.20412.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dne ètvrtek 22 únor 2007 00:00 Marcel Holtmann napsal(a):
> Hi Michal,
>
> > I need this for differing Option "XkbModel" in Xorg, so I can bind to
> > each device it's model and has correct xev's scancodes based on model. So
> > I prefer to have as Phis just only BDADDR, because for me this doesn't
> > make sense to have there device to which keyboard connect. Then I should
> > have 1 section for each receiver, which is stupid.
>
> it makes sense to make it analogous to the USB driver, where the phys
> includes the USB path. The equivalent for Bluetooth is the source plus
> destination.
>
> > Section "InputDevice"
> >         Identifier  "Bluetooth Keyboard"
> >         Driver      "kbd"
> >         Option  "Name"  "Bluetooth HID Boot Protocol Device"
> >         Option  "Phis"        "BDADDR"
> >         Option      "XkbRules"  "xfree86"
> >         Option      "XkbModel"  "dinovo"
> >         Option      "XkbLayout" "us"
> > EndSection
>
> I don't know how "Phis" suppose to work, but I might think it is better
> using vendor and product ID for matching.

Xorg just reads lines from devices and match devices against it. So Phis makes 
configuration easier ;), because only one line is enough to match device.

>
> Regards
>
> Marcel

Michal
