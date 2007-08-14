Return-Path: <linux-kernel-owner+w=401wt.eu-S1763047AbXHNP6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763047AbXHNP6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbXHNP6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:58:02 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:50560 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504AbXHNP6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:58:01 -0400
From: Daniel Exner <webmaster@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: David Brownell <david-b@pacbell.net>
Subject: Re: EHCI Regression in 2.6.23-rc2
Date: Tue, 14 Aug 2007 17:57:23 +0200
User-Agent: KMail/1.9.7
Cc: Stuart_Hayes@dell.com, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, jikos@jikos.cz, greg@kroah.com
References: <200708101045.57166.dex@dragonslave.de> <200708141146.43215.webmaster@dragonslave.de> <20070814154237.DF0FB2350CA@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
In-Reply-To: <20070814154237.DF0FB2350CA@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708141757.24787.webmaster@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;webmaster@dragonslave.de;1187107080;9654dff5;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> > ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> >
> > Build into:
> > 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge
> > [K8T800/K8T890 South]
>
> Yeah, VT8235 was their first southbridge with integrated EHCI.
> ISTR that the VT8237 worked a bit more smoothly.
>
> I think 8237 was about where they forked off the the VT6212 as
> their first discrete EHCI (for addon cards) claiming EHCI 1.0
> conformance.  Too bad they didn't recycle all the VT6202 chips
> in their inventory at that time...
No hardware producer would have done that ;)

> Now ... are you reporting that this worked with Stuart's patch?
> Or that it didn't?  Or that you couldn't say?
As I started this thread because Stuart's patch freezes my whole system (at 
least my bitsect did blame him), I therefore report that it doesnt work for 
me.




Greetings
Daniel Exner
