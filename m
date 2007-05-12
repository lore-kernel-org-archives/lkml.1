Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbXELSvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbXELSvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbXELSva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:51:30 -0400
Received: from nn7.de ([85.214.94.156]:43684 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990AbXELSv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:51:29 -0400
Subject: converting appletouch to usb autosuspend...
From: Soeren Sonnenburg <kernel@nn7.de>
To: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 12 May 2007 20:51:26 +0200
Message-Id: <1178995886.4168.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I've realized using the great powertop ( http://www.linuxpowertop.org/ )
that loading the appletouch driver (and touching it once) makes consumes
about 0.3 W even when not touching the pad. As rmmod'ing appletouch
fixes this I wonder why the driver does not do this alone. So my
question is what does one have to do to convert a driver (such as
appletouch) to make use of usb autosuspend except for

 .supports_autosuspend = 1

...

While we are at it usb related powerhogs on this macbook pro are
uhci_hcd (usb keyboard) and usb_hcd_poll_rh_status (rh_timer_func)
too...

Soeren.
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
