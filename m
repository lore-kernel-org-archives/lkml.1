Return-Path: <linux-kernel-owner+w=401wt.eu-S934013AbYBUWK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013AbYBUWK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758552AbYBUWKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:10:12 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4846 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760235AbYBUWKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:10:10 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: problem with starting 2.5.26-rc1 and latest git
Date: Thu, 21 Feb 2008 23:10:04 +0100
User-Agent: KMail/1.9.7
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <200802132316.03155.m.kozlowski@tuxland.pl> <20080218142832.3a092dd5@hyperion.delvare> <200802200056.25543.m.kozlowski@tuxland.pl>
In-Reply-To: <200802200056.25543.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802212310.05211.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > > Of course there is a typo in the subject :)
> > > 
> > > 2.5.25-rc1 -> 2.6.25-rc1
> > > 
> > > > Hello,
> > > > 
> > > > 	I tried 2.6.25-rc1 and latest git on my laptop (x86 32bit) and have a problem.
> > > > Linux boots but with huge delay due to some issue with loading usb modules.
> > > > Udev complains:
> > > > 
> > > > 'Could not lock modprobe uhci_hcd'
> > > > 'Could not lock modprobe yenta_socket'
> > > > 'Unknown symbol usb_*'
> > > > 'Gave up waiting for init of module usbcore'
> > > > (...)
> > 
> > Have you tried upgrading to rc2? I used to have the same problem you
> > reported, but I was unable to reproduce it since I upgraded to rc2.

Bad news is I tested rc2 and it still happens. Good news is I also tried
latest git - e80af3a8 and it works fine!

	Mariusz
