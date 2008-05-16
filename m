Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbYEPHT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbYEPHT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 03:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756411AbYEPHTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 03:19:42 -0400
Received: from styx.suse.cz ([82.119.242.94]:55353 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756148AbYEPHTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 03:19:40 -0400
Date: Fri, 16 May 2008 09:19:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tino Keitel <tino.keitel@gmx.de>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <greg@kroah.com>,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: add appleir USB driver
In-Reply-To: <20080515205950.GA11794@dose.home.local>
Message-ID: <Pine.LNX.4.64.0805160917350.11363@jikos.suse.cz>
References: <20080514221519.GA6575@kroah.com> <20080515132108.GA9327@dose.home.local>
 <20080515094212.ZZRA012@mailhub.coreip.homeip.net> <20080515174939.GA10881@dose.home.local>
 <20080515142845.ZZRA012@mailhub.coreip.homeip.net> <20080515205950.GA11794@dose.home.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Tino Keitel wrote:

> Does setting the quirks to 0 lead to the creation of a HID device 
> immediately? 

The easiest way is either to handle this in the early stage, i.e. specify 
'quirks' module parameter during the module insertion.

Other possibility is to detach the driver from the device using 'unbind' 
functionality of sysfs. libusb has a call for this too.

> Where is this documented? 

modinfo usbhid.ko

-- 
Jiri Kosina
SUSE Labs
