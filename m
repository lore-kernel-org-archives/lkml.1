Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbXJ2Wo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbXJ2Wo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXJ2Wov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:44:51 -0400
Received: from nebuchadnezzar.smejdil.cz ([195.122.194.203]:59236 "EHLO
	nebuchadnezzar.smejdil.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbXJ2Wou convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:44:50 -0400
X-Greylist: delayed 874 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 18:44:50 EDT
From: CIJOML <cijoml@volny.cz>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: Phis in /proc/bus/input/devices same for all devices?
Date: Mon, 29 Oct 2007 23:29:54 +0100
User-Agent: KMail/1.9.7
Cc: "Marcel Holtmann" <marcel@holtmann.org>, linux-kernel@vger.kernel.org
References: <200702212313.30359.cijoml@volny.cz> <200702220002.20412.cijoml@volny.cz> <d120d5000702220709j9c98delcdf9a45e298ac39f@mail.gmail.com>
In-Reply-To: <d120d5000702220709j9c98delcdf9a45e298ac39f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710292329.54895.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dne èt 22. února 2007 Dmitry Torokhov napsal(a):
> On 2/21/07, CIJOML <cijoml@volny.cz> wrote:
> > Dne ètvrtek 22 únor 2007 00:00 Marcel Holtmann napsal(a):
> > > Hi Michal,
> > >
> > > > I need this for differing Option "XkbModel" in Xorg, so I can bind to
> > > > each device it's model and has correct xev's scancodes based on
> > > > model. So I prefer to have as Phis just only BDADDR, because for me
> > > > this doesn't make sense to have there device to which keyboard
> > > > connect. Then I should have 1 section for each receiver, which is
> > > > stupid.
> > >
> > > it makes sense to make it analogous to the USB driver, where the phys
> > > includes the USB path. The equivalent for Bluetooth is the source plus
> > > destination.
> > >
> > > > Section "InputDevice"
> > > >         Identifier  "Bluetooth Keyboard"
> > > >         Driver      "kbd"
> > > >         Option  "Name"  "Bluetooth HID Boot Protocol Device"
> > > >         Option  "Phis"        "BDADDR"
> > > >         Option      "XkbRules"  "xfree86"
> > > >         Option      "XkbModel"  "dinovo"
> > > >         Option      "XkbLayout" "us"
> > > > EndSection
> > >
> > > I don't know how "Phis" suppose to work, but I might think it is better
> > > using vendor and product ID for matching.
> >
> > Xorg just reads lines from devices and match devices against it. So Phis
> > makes configuration easier ;), because only one line is enough to match
> > device.
>
> They can get vendor and id from /proc/input/devices as well. Plus I
> will export uniq in /proc/bus/input/devices and then yo can ask X guys
> to allow matching on uniq as well.

Hi Dmitri,

I watched at 2.6.23 and this is still not done yet. Are there any patches 
available to use???

Thanks a lot for reply

Michal
