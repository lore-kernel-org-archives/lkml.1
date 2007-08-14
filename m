Return-Path: <linux-kernel-owner+w=401wt.eu-S1764800AbXHNGoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764800AbXHNGoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 02:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbXHNGoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 02:44:17 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:39624 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751917AbXHNGoP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 02:44:15 -0400
From: Daniel Exner <webmaster@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: David Brownell <david-b@pacbell.net>
Subject: Re: EHCI Regression in 2.6.23-rc2
Date: Tue, 14 Aug 2007 08:43:41 +0200
User-Agent: KMail/1.9.7
Cc: Stuart_Hayes@dell.com, greg@kroah.com, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, jikos@jikos.cz
References: <200708101045.57166.dex@dragonslave.de> <DFEF91B22ED07447AB6AA4B237F913F9B18E4E@ausx3mpc125.aus.amer.dell.com> <200708131516.18675.david-b@pacbell.net>
In-Reply-To: <200708131516.18675.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708140843.42196.webmaster@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;webmaster@dragonslave.de;1187073855;8503a017;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Monday 13 August 2007, Stuart_Hayes@dell.com wrote:
> > With the VIA controller I have,
>
> Which kind is that?  The VT6202 is buggy as all get-out, and
> they sold a *LOT* of those discrete chips for use in add-on PCI
> cards.  We generally warn people away from those.  A more current
> version is the VT6212, which was much more usable.  (If it says
> EHCI 0.95, it's a VT6202... their EHCI 1.0 chips were much better.)
Where exactly should I search for this? Neither lspci nor lsusb showed any 
hint on the EHCI rev. the chip conforms to..

[..]
> > Perhaps for now the best thing would just be to bypass the EHCI CPU
> > frequency notifier code (i.e., my patch) for VIA EHCI controllers, since
> > they are broken.  Would a hard-coded blacklist (just an "if
> > (manufacturer==VIA)..." type thing) be OK?
>
> Yes ... although if you don't need to blacklist their EHCI 1.0 chips
> don't do it.  (Any VIA EHCI integrated into a southbridge is going
> to follow spec rev 1.0 pretty well, modulo idiosyncratic timings.)
I guess its needed to blacklist even the ECHI 1.0 chips, since my problem is
with exactly one of those ;)

I'm not really into USB protocol specs, but perhaps its possible to test 
wether the problem Stuarts patch addressed can actually happen on VIA EHCI 
chips? Perhaps those guys solved the problem in Hard/Firmware..

> > I've also acquired a card with an NEC EHCI controller on it, which I'm
> > going to look at while I'm into it...
>
> Another case where there are a lot of add-on "EHCI 0.95" cards; but
> in this case the quirks were less significant.
Some guy donated me a PCMCIA card with one of those, cause it'll wont work in 
his Windows only Notebook :)



Greetings
Daniel Exner
