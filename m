Return-Path: <linux-kernel-owner+w=401wt.eu-S932140AbXDKUnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbXDKUnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbXDKUnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:43:53 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59931 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbXDKUnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:43:52 -0400
Date: Wed, 11 Apr 2007 13:43:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Helge Hafting <helgehaf@aitel.hist.no>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
Message-Id: <20070411134346.d10765da.akpm@linux-foundation.org>
In-Reply-To: <20070411194227.GA31286@aitel.hist.no>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
	<20070411194227.GA31286@aitel.hist.no>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 21:42:27 +0200
Helge Hafting <helgehaf@aitel.hist.no> wrote:

> 2.6.21-rc6-mm1 locks up during boot.
> The last message is:
> usbcore: registered new interface driver hiddev
> 
> Then it hangs so hard that not even sysrq+B have any effect.
> 
> With 2.6.18-rc5-mm1, the next messages I normally get are:
> usbcore: registered new interface driver usbhid
> drivers/usb/input/hid-core.c: v2.6:USB HID core driver
> usbcore: registered new interface driver usbserial
> 
> This is a x86-64 single processor
> 

OK.  If you add initcall_debug to the kernel boot command line, what's the
last thing we call?

