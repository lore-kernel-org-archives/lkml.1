Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbZABSQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbZABSQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbZABSPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:15:45 -0500
Received: from eazy.amigager.de ([213.239.192.238]:46355 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851AbZABSPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:15:44 -0500
Date: Fri, 2 Jan 2009 19:15:38 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Mark Lord <lkml@rtr.ca>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, linux-usb@vger.kernel.org
Subject: Re: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't
	be unplugged safely
Message-ID: <20090102181538.GA26389@dose.home.local>
Mail-Followup-To: Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
	gregkh@suse.de, linux-usb@vger.kernel.org
References: <20090101160343.GA4278@thyme.bj.intel.com> <20090102095643.GB17103@x61> <495E37BC.1040101@rtr.ca> <495E37E9.80903@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495E37E9.80903@rtr.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 10:51:05 -0500, Mark Lord wrote:
> Mark Lord wrote:

[...]

>> Incidently, the WD Passport drives support SG_IO,
>> so things like hdparm and smartctl can work with them as well.
> ..
>
> s/SG_IO/SG_IO+SAT/

The issue I noticed with the WD Passport drives is that the hard disk
won't spin down with /usr/bin/eject, which is used by HAL if the user
ejects the device (i.e.  via his desktop environment).  The WD Passport
drives need to be set into a sleep power condition. Something
like "sg_start --pc=3 /dev/sdX" needs to be used in this case.

I just checked hdparm -Y, and this works too.

Regards,
Tino
