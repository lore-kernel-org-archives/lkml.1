Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbXGHE11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbXGHE11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 00:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbXGHE1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 00:27:17 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37496 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbXGHE1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 00:27:17 -0400
X-Sasl-enc: 2x5argo7YAATjDd01RtkqKx8p6Lfuv2POOSLWbNbAKeG 1183868836
Date: Sun, 8 Jul 2007 01:27:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Gerald Britton <gbritton@doomcom.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Tim Hull <thully@umich.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: MacBook makes whining noise when usb-uhci active
Message-ID: <20070708042712.GC12052@khazad-dum.debian.net>
References: <9a7c669e0707071551v2705320dn876ad208fa60a537@mail.gmail.com> <Pine.LNX.4.44L0.0707072210470.10912-100000@netrider.rowland.org> <20070708025457.GA2822@zante.sekrit.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070708025457.GA2822@zante.sekrit.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Jul 2007, Gerald Britton wrote:
> On Sat, Jul 07, 2007 at 10:17:34PM -0400, Alan Stern wrote:
> > > [2.] Full description of the problem/report: On my MacBook (first generation
> > > Core Duo 1.83GHz), I can hear a faint whining noise that becomes audible
> > > when usb-uhci is loaded and remains audible except when the USB ports are in
> > > use (i.e. the noise temporarily stops when I'm copying music to my iPod).
> > 
> > You have a USB keyboard, right?  So the ports are always in use -- 
> > unless you unplug the keyboard.
> > 
> > > This problem occurs on both 2.6.21  and 2.6.22-rc7, but does not occur on
> > > 2.6.18.  Unloading usb-uhci when booted in 2.6.22-rc7 makes the whining
> > > noise stop, but the system is useless in this state for obvious reasons.
> > > The same whine does occur in OS X that occurs in 2.6.22-rc7 (though it does
> > > NOT occur in 2.6.18)
> > 
> > Anyway it's clearly a hardware problem, even if it is triggered by 
> > something in software.  About all I can suggest is to surround the 
> > MacBook with something sound-absorbent.  (Not very helpful, I agree.)
> 
> I have a similar problem with my new Thinkpad X60 Tablet.  In this case,
> I have a high pitched whine which is only caused when USB drivers are loaded,
> I am on battery, and there are no devices connected to USB.  I suspect
> something involved with CONFIG_USB_SUSPEND (which is enabled) is causing this
> whine, but I haven't dug deeper to find out a more precise cause.
> 
> For reference, I'm running Fedora 7's 2.6.21-1.3228.fc7 x86_64.

http://www.thinkwiki.org/wiki/Problem_with_high_pitch_noises  might give you
some hints, and yes, it is a hardware design problem.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
