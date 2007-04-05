Return-Path: <linux-kernel-owner+w=401wt.eu-S1946093AbXDEIcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946093AbXDEIcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946090AbXDEIcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:32:00 -0400
Received: from styx.suse.cz ([82.119.242.94]:36641 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992431AbXDEIb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:31:58 -0400
Date: Thu, 5 Apr 2007 10:36:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Adam Kropelin <akropel1@rochester.rr.com>
Cc: Li Yu <raise.sail@gmail.com>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Marcel Holtmann <marcel@holtmann.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
In-Reply-To: <036401c77711$cee286d0$84163e05@kroptech.com>
Message-ID: <Pine.LNX.4.64.0704051034100.4173@jikos.suse.cz>
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com>
 <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn>
 <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz>
 <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>
 <1175516515.5815.347.camel@violet> <Pine.LNX.4.64.0704021429420.3808@jikos.suse.cz>
 <1175532439.5815.375.camel@violet> <4611AAC1.8050303@gmail.com>
 <Pine.LNX.4.64.0704031053140.3808@jikos.suse.cz> <02f801c7770d$3eafb050$84163e05@kroptech.com>
 <Pine.LNX.4.64.0704050109500.4173@jikos.suse.cz> <036401c77711$cee286d0$84163e05@kroptech.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Adam Kropelin wrote:

> > hiddev will have to stay for quite some time, exactly because of 
> > backward compatibility with userspace applications/drivers that use it 
> > (I am not aware of many of them though, but apparently there are 
> > some).
> Apcupsd is the one on my mind, but I believe there are others.

I am aware only of apcupsd, nut and hid2hci.

> On Apcupsd we've recently introduced a libusb-based driver that does all 
> HID parsing in userspace. Not only does that free us from hiddev, it 
> also frees us from the umpteen other proprietary HID interfaces across 
> various platforms. Although the hiddev-based driver is still the default 
> for Linux platforms, I plan to change that in the next major release and 
> thus begin migrating folks off of hiddev.

Great. Do you use libusb to obtain raw hid events? Could you by any chance 
look at current implementation of hidraw (it's in -mm or I can send it to 
you as a separate patch) and check whether you have any comments on this? 
It would be good if you could use hidraw rather than reading raw usb data 
through libusb.

Thanks.

-- 
Jiri Kosina
