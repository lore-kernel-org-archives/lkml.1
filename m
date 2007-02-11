Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbXBKAaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbXBKAaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 19:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbXBKAaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 19:30:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35422 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbXBKAaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 19:30:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tilman Schmidt <tilman@imap.cc>
Subject: Re: NAK new drivers without proper power management?
Date: Sun, 11 Feb 2007 01:27:34 +0100
User-Agent: KMail/1.9.5
Cc: nigel@nigel.suspend2.net, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171147026.19894.16.camel@nigel.suspend2.net> <45CE5934.3020801@imap.cc>
In-Reply-To: <45CE5934.3020801@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702110127.35631.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 February 2007 00:45, Tilman Schmidt wrote:
> Am 10.02.2007 23:37 schrieb Nigel Cunningham:
> > If your device requires power management, and you know it requires power
> > management, why not just implement power management? Doing -ENOSYS
> > instead is like saying -ESPAMMEBECAUSEIMLAZY.
> 
> Like it or not, power management is far from trivial, and people
> writing device drivers have limited resources. Calling them lazy
> does not help that in the least. If you try to put pressure on them
> by refusing to merge their work as long as it doesn't provide this
> or that functionality, you *may* end up with a few drivers having
> that functionality which otherwise wouldn't, but you *will* also
> end up with a number of drivers never making it into the kernel
> because their authors just have to give up.
> 
> Also, in your argument you neglected a few cases:
> - What if my device does not require power management?
> - What if I don't know whether my device requires power management?
> - What if I know my device would require power management, but don't
>   know how to implement it?

Plus:
- What if I'm planning to implement the power managemet, but not just right
now?
 
> > Let me put it another way: People keep talking about Linux being ready
> > for the desktop. To me at least (but I dare say for lots of other people
> > too), being ready for the desktop means that things just work, without
> > having to recompile kernels or bug driver authors or wait twelve
> > months. 
> 
> Exactly.
> 
> > And it means that doing a bare minimum isn't enough. We keep claiming
> > that Open Source is better than Proprietary software. If we accept
> > half-pie jobs of implementing support for anything - driver power
> > management support or hibernation support or whatever - as 'good
> > enough', we're undercutting that argument. Linux's power management
> > support should - as far as we're able - be at least as good as that
> > other operating system's and preferably way, way better.
> > 
> > -ENOSYS is just not acceptable.
> 
> Your argument falls down the moment you consider the alternative:
> not merging the driver means that the device won't work at all.
> (Given that out-of-tree drivers are actively discouraged, to put
> it mildly.) That's arguably farther from "desktop readiness" than
> a device not supporting power management.

Agreed.

Greetings,
Rafael
