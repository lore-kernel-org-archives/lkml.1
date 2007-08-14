Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbXHNJrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbXHNJrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 05:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbXHNJrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 05:47:20 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:35227 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753757AbXHNJrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 05:47:18 -0400
From: Daniel Exner <webmaster@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: David Brownell <david-b@pacbell.net>
Subject: Re: EHCI Regression in 2.6.23-rc2
Date: Tue, 14 Aug 2007 11:46:42 +0200
User-Agent: KMail/1.9.7
Cc: Stuart_Hayes@dell.com, greg@kroah.com, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, jikos@jikos.cz
References: <200708101045.57166.dex@dragonslave.de> <200708140843.42196.webmaster@dragonslave.de> <200708140101.19651.david-b@pacbell.net>
In-Reply-To: <200708140101.19651.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708141146.43215.webmaster@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;webmaster@dragonslave.de;1187084838;cebbf675;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Monday 13 August 2007, Daniel Exner wrote:
[..]
> > Where exactly should I search for this? Neither lspci nor lsusb showed
> > any hint on the EHCI rev. the chip conforms to..
>
> The driver logs that information as it starts; on this sytem:
>
>  ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
>
> vs "EHCI 0.95".
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004

Build into:
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge [K8T800/K8T890 
South]

> > > > I've also acquired a card with an NEC EHCI controller on it, which
> > > > I'm going to look at while I'm into it...
> > >
> > > Another case where there are a lot of add-on "EHCI 0.95" cards; but
> > > in this case the quirks were less significant.
> >
> > Some guy donated me a PCMCIA card with one of those, cause it'll wont
> > work in his Windows only Notebook :)
>
> A NEC 0.95 ??  Should be fine with Linux.  Assuming no bugs have
> crept in.
Didn't test it yet with 2.6.23-rc2 or rc3, but up to 2.6.22 it was fine :)

Regarding the option to blacklist VIA in the module:
I would prefer blacklisting VIA by default but giving the module some 
parameter like "honours inactive bit" to override this.

Perhaps there are newer VIA Chips out there, that indeed do this and some 
users trigger happy enough to test this. :)

Greetings
Daniel Exner
