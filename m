Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbXD0Wzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbXD0Wzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757536AbXD0Wzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:55:52 -0400
Received: from styx.suse.cz ([82.119.242.94]:50174 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757528AbXD0WzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:55:00 -0400
Date: Sat, 28 Apr 2007 00:55:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <greg@kroah.com>, "VE (HOME)" <ve@vetienne.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, fubar@us.ibm.com,
       Paul Walmsley <paul@booyaka.com>
Subject: Re: USB HID bug (was [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1)
In-Reply-To: <Pine.LNX.4.64.0704280024170.7370@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0704280054030.7370@jikos.suse.cz>
References: <200704262058.33087.ve@vetienne.net> <20070426211146.f370cf81.akpm@linux-foundation.org>
 <010a01c788ae$0a7d0140$5601a8c0@apws2> <20070427211836.GC5917@kroah.com>
 <Pine.LNX.4.64.0704280024170.7370@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Jiri Kosina wrote:

> This BUG (it's in fact a warning) is this one:
>        WARN_ON(idVendor == 0);
> I now don't immediately see how this could happen - the vendor ID seems 
> to be propagated properly from hid_probe() (nothing has been changed in 
> this codepath), so this would mean that hid_probe() has been passed 
> usb_interface for which 
> le16_to_cpu(interface_to_usbdev(intf).dev->descriptor.idVendor) is equal 
> to zero ...  and this definitely shouldn't happen for any sane device 
> (could the original poster please verify with lsusb, just to be 100% 
> sure?).

BTW do I guess correctly that your keyboard is useful without problems 
after that, you only see this BUG and stacktraces in your logs, right?

Thanks,

-- 
Jiri Kosina
SUSE Labs
