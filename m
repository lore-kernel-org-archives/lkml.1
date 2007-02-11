Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbXBKAqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbXBKAqf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 19:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbXBKAqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 19:46:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35466 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbXBKAqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 19:46:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: NAK new drivers without proper power management?
Date: Sun, 11 Feb 2007 01:44:16 +0100
User-Agent: KMail/1.9.5
Cc: nigel@nigel.suspend2.net, linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <fa.kop49l/7yexJoUGrzk6vVeIP934@ifi.uio.no> <45CE533C.4010108@shaw.ca>
In-Reply-To: <45CE533C.4010108@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702110144.17783.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 February 2007 00:20, Robert Hancock wrote:
> Nigel Cunningham wrote:
> > If your device requires power management, and you know it requires power
> > management, why not just implement power management? Doing -ENOSYS
> > instead is like saying -ESPAMMEBECAUSEIMLAZY.
> > 
> > Let me put it another way: People keep talking about Linux being ready
> > for the desktop. To me at least (but I dare say for lots of other people
> > too), being ready for the desktop means that things just work, without
> > having to recompile kernels or bug driver authors or wait twelve
> > months. 
> > 
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
> Well, it's probably more acceptable than silently doing nothing and the 
> device failing or locking up the machine on resume, but I couldn't agree 
> more that it's not what we want to be encouraging. Perfect may be the 
> enemy of the good, but "works except no power management" is hardly what 
> I would call good these days, more like pretty sloppy..

I think there are situations in which it can be justified, like:
- The driver is not entirely finished, but we want to merge it early, because
of many potential users,
- The driver has only a few users who aren't interested in the suspend/resume
functionality,
- The device is undocumented and we don't know how to make it handle the
suspend/resume (we may learn that in the future or not).

For this reason I 100% agree that we should _encourage_ implementing .suspend
and .resume, but we should not make it an unbreakable rule cast in stone.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
