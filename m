Return-Path: <linux-kernel-owner+w=401wt.eu-S1765427AbXHWSab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765427AbXHWSab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 14:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763614AbXHWSaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 14:30:21 -0400
Received: from mailfe03.tele2.dk ([212.247.154.67]:34168 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759388AbXHWSaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 14:30:21 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2007 14:30:20 EDT
X-Cloudmark-Score: 0.000000 []
Subject: Re: Forcedeth: Nvidia NIC goes up and down
From: Anders Rune Jensen <anders@gnulinux.dk>
To: linux-kernel@vger.kernel.org
Cc: "jos.huisken" <jos.huisken@kpnplanet.nl>
In-Reply-To: <181B3AA5E931BA4AB8ED25976193DDC30137416B@CPEXBE-VOIP03.bbp.local>
References: <181B3AA5E931BA4AB8ED25976193DDC30137416B@CPEXBE-VOIP03.bbp.local>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 03:40:21 +0200
Message-Id: <1187919621.8533.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 22:43 +0200, jos.huisken@kpnplanet.nl wrote:
> Hi,
> 
> 
> I have a similar issue. The network drops away randomly for short periods (several to ten(s) seconds).
> Strange enough nothing is reported is syslog, and indeed from the machine itself pinging works perfectly to another machine.
> From that other machine however the connections looks dead in those periods...
> 
> I'm running kernel 2.6.18.8-0.5-default on a SUSE 10.2 machine with a ASUS M2NPV-VM board.
> Have tried both the default "0.59" and "0.62-Driver Package V1.23" version of forcedeth
> Tried 2 BIOSes: 0901 and 1001.
> 
> Also have tried several kernel options independently: noapic, pci=routeirq, acpi=off, pci=nomsi
> All did not help.
> 
> 
> Any suggestions?

I got it working by connecting the network card my old 100mbit hub. It
seems that the problem is only when it runs a 1gbit. So my setup is now
1gbit switch <> computers, 1mbit hub <> machine with broken netcard.

This is good enough for now, since I don't really transfer that much
data to and from the machine, but of course I would like to have 1gbit
working for when I actually do need it ;-)

> BTW I'm not subscribed, please CC me personally.
> 
> 
> Thanks in advance,
> -- Jos

--
Anders Rune Jensen
http://people.iola.dk/anders/

