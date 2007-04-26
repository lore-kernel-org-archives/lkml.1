Return-Path: <linux-kernel-owner+w=401wt.eu-S1031439AbXDZSqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031439AbXDZSqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031437AbXDZSqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:46:51 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:51171 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1031436AbXDZSqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:46:50 -0400
Date: Thu, 26 Apr 2007 20:38:34 +0200
To: Jiri Kosina <jikos@jikos.cz>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
Message-ID: <20070426183833.GA18182@aitel.hist.no>
References: <20070408143559.f5014629.akpm@linux-foundation.org> <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org> <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704122023510.12991@twin.jikos.cz> <20070412202519.GB14705@aitel.hist.no> <Pine.LNX.4.64.0704130107170.12991@twin.jikos.cz> <462F2558.5010909@aitel.hist.no> <Pine.LNX.4.64.0704251324540.20657@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704251324540.20657@twin.jikos.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Helge Hafting <helgehaf@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I recompiled 2.6.21-rc6-mm1 from fresh sources.
It still hangs initializing USBm but this time your
patch applied.

I rebooted with your patch, and got:

Detailed lists of all the USB devices found
(printer,mouse,...)
Then usbcore registered various drivers, such as
usblp, usb-storage, libusual, usbserial, ipaq
These messages were intermixed with messages from
the md raid system initializing

The three last lines were:
sdhci: Secure digital host controller interface driver
sdhci: copyright Pierre Ossman
usbcore: registered new interface driver hiddev

And then the machine hung completely.  I'll have
a look at bisecting. :-(
