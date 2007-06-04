Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbXFDQec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbXFDQec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757566AbXFDQeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:34:13 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53286 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756457AbXFDQeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:34:12 -0400
X-Sasl-enc: eGk6QlEyCEjZvWZ7XgPM2mMBWZ2YA1SVgZVKGd1GX9ib 1180974850
Date: Mon, 4 Jun 2007 13:34:06 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Andi Kleen <ak@suse.de>,
       Jiri Kosina <jikos@jikos.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Message-ID: <20070604163406.GA1120@khazad-dum.debian.net>
References: <20070604112426.GA2707@elf.ucw.cz> <20070604130903.GC1971@elf.ucw.cz> <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz> <200706041543.49071.ak@suse.de> <20070604135427.GA19466@elf.ucw.cz> <d120d5000706040702q3b5251e8oc5e9f3c198f060bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000706040702q3b5251e8oc5e9f3c198f060bd@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Jun 2007, Dmitry Torokhov wrote:
> >...but I'm not quite sure it is a buggy keyboard. It happens _way_ too
> >often. Launch the line above and try to do some typing...
> 
> This used to work fine on my box last time I tried it (the switch
> itself is offloaded to a keventd and shoud not get in the way) but
> then they push all kind of ACPI/SMM crap together with KBC so who
> knows... I should try it again when I get home.

Err... in laptops, almost *always* the KDC is emulated by the embedded
controller, so I bet you're right on the money, there.  It is not "a buggy
KDC", it is a buggy EC firmware and/or buggy SMBIOS which is a lot more
common.

And DoS'ing the EC is very high on the Don't Do That list on a laptop.  If
the X60 is only losing keypresses and producing no bigger fireworks, that's
outstanding behavior (as far as I trust ThinkPad firmware, anyway).

So please throttle anything that might access the KDC way too much (as
compared to normal keyboard operation by an user).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
