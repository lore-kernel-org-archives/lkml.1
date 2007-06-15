Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbXFOIy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbXFOIy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 04:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbXFOIyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 04:54:18 -0400
Received: from mx.laposte.net ([81.255.54.16]:29097 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXFOIyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 04:54:17 -0400
Message-ID: <46063.192.54.193.51.1181897652.squirrel@rousalka.dyndns.org>
Date: Fri, 15 Jun 2007 10:54:12 +0200 (CEST)
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
To: "David Schwartz" <davids@webmaster.com>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc7
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote :

> The GPL is about having the legal right to modify the software and
being
> able to put other people's distributed improvements back into the
> original code base. It does not guarantee that you will actually be
able
> to modify the software and get it to work on some particular hardware.

This is obviously wrong.

Need I remind everyone the "origin" of the GNU movement is RMS getting
a buggy printer driver from its manufacturer, and finding out he had
no way to fix it? What use would RMS have had for putting other
people's distributed improvements back into the original code base and
not being allowed to get his printer to work? (And yes driver was
os-side but only because devices had little computing capabilities
then. Nowadays a lot of this very same stuff happens on the
DRM-protected flashable firmware)

The aim from the start was for the ultimate software recipient (not
the software author) to be able to fix a software blob provided with a
hardware device, and use it with the original hardware device.
Translated on modern hardware that's exactly what people (even
non-developper people) do when they download a rockbox image and put
it on their MP3 player, and exactly the use case DRM forbids.

The plain truth is the GPL v2 didn't target explicitely DRM when it
was written because hardware manufacturers hadn't come up with DRM
yet. Getting source code available was sufficient because no one
"protected" hardware against binaries built from this source code, and
embedded hardware logic was either bog-simple and foolproof because
neither the manufacturer nor anyone else could change it, or wide open
to everyone (the manufacturer but also the buyer of the device).

Modern DRM targets this original GPL assumption. GPLv3 only clarifies
the intended effects of previous GPL versions.

It is a shameless rewriting of history to say the GPLv2 writers
considered DRM and wrote a license that allowed it. It is a shameless
rewriting of history to claim anyone (Linus included) who released GPL
v2 code before DRM was used considered DRM and okayed it. It is a
shameless rewriting of history to claim the GPLv3 "spirit" WRT
combined software + hardware bundles is any different from the GPLv2
one.

The first documented reason for free/libre software was a
software+hardware bundle. They never were isolated parts.

Moreover many people write about GPLv3 imposing "software" rules on
"hardware" design. DRM is wholly about using "software" rules on
hardware design. Hardware can be broken and the law allows buyers to
break what they bought. The attractiveness of DRM to hardware
manufacturers and content producers is precisely it's not hardware,
but software that has many interesting legal properties:
- it's not sold but licensed, and you can attach strings to the
license you can't on a pure hardware deal (Hardware is not licensed.
An hardware design may be licensed to other manufacturers, but the
hardware implementation buyers receive has no particular legal
protection against modifications)
- copyright law gives you exclusive rights (supposedly for a time), so
you can legaly lock out users and competitors when the law is very
clear you're not allowed to for hardware. So to take the ROM case it's
very difficult for a user to take a ROM out and replace it with
something else. However he can legally do it. Aside from introducing
an assymetry between the user and the manufacturer, DRM makes
replacement legally forbidden. GPLv3 does not target the technical
difficulty but the new legal impossibility (by forcing the GPLv3
distributor to relinquish any legal entitlement to block changes on
the GPLv3 part. That it also unlocks the rest of the device is only
cheap design that does not distinguish between the parts it blocks)

Now kernel authors can choose whatever license they want for code they
wrote. They can specify the conditions of acceptance of submitted
patches (but not what the authors of the submitted patches think about
the GPLv3). They definitively do not have to switch to the GPLv3 just
because the FSF released it.

However if they want to discuss the rationality of their choice of
GPLv2 over GPLv3, it would be nice to get rational arguments and not
the gross exagerations, name-callings and dubious analogies this
thread is full of.

-- 
Nicolas Mailhot

