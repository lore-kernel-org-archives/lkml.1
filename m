Return-Path: <linux-kernel-owner+w=401wt.eu-S1030301AbXDKTtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030301AbXDKTtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030297AbXDKTtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:49:14 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:51158 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030298AbXDKTtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:49:12 -0400
Date: Wed, 11 Apr 2007 21:42:27 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
Message-ID: <20070411194227.GA31286@aitel.hist.no>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070408143559.f5014629.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Helge Hafting <helgehaf@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.21-rc6-mm1 locks up during boot.
The last message is:
usbcore: registered new interface driver hiddev

Then it hangs so hard that not even sysrq+B have any effect.

With 2.6.18-rc5-mm1, the next messages I normally get are:
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
usbcore: registered new interface driver usbserial

This is a x86-64 single processor

Helge Hafting
