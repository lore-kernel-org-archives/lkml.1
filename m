Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZAARpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZAARpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 12:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbZAARo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 12:44:57 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:48961 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbZAARo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 12:44:57 -0500
Date: Thu, 1 Jan 2009 18:44:54 +0100
From: Andreas Mohr <andi@lisas.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: cannot reliably detect USB device
Message-ID: <20090101174453.GA3805@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225104753.GB15733@localhost>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > I have a pl2303 USB-RS232 converter that cannot be reliably
> > > detected.
> > 
> > Faulty hardware?  Flaky cables?  Bad connections?  If this is
> > reproducable for the same device on multiple machines, I'd just go buy
> > a
> > new device :)
> 
> I decided to give it a last try before planning a replacement - then I
> find that /dev/ttyUSB0 could be created if I enlarge the retry times.
> 
> It could take 10 seconds to get a valid response. It must go crazy.

Detected _instantly_ on 2.6.28 here:

[59750.560209] usb 1-1: USB disconnect, address 5
[59750.561888] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[59750.561970] pl2303 1-1:1.0: device disconnected
[59752.904108] usb 1-1: new full speed USB device using uhci_hcd and address 6
[59753.059546] usb 1-1: configuration #1 chosen from 1 choice
[59753.061460] pl2303 1-1:1.0: pl2303 converter detected
[59753.114738] usb 1-1: pl2303 converter now attached to ttyUSB0

(the 3-second delay basically was me waiting before reinserting)


Bus 001 Device 006: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port

Label: "GMUS-03 USB Serial Adapter"

Detection test only, _not_ used for actual serial communication currently...


But there are more PL2303 adapters than flies on this planet,
thus someone else also has some input on this?

Andreas Mohr
