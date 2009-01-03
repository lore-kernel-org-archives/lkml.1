Return-Path: <linux-kernel-owner+w=401wt.eu-S932468AbZACCYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbZACCYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 21:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758832AbZACCYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 21:24:09 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:23548 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758727AbZACCYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 21:24:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=iT0wB/QetMSqdy3r/vxV/Wdp9ZxSppchUiQdD1qM3EVESpu2cAnwCR5s6zMEEYr+UV
         OiUZVHpmwpJIAPqQR1nYEozcXKMggtLqpZII0itrPV2CgIIfiti6l3c0srXM+c2QW2CY
         QLjAdbEfoPF8i0SSpxF2aoD3Mo2W0ZwSvmbaE=
Date: Sat, 3 Jan 2009 10:24:01 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Tino Keitel <tino.keitel@gmx.de>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, linux-usb@vger.kernel.org
Subject: Re: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't
	be unplugged safely
Message-ID: <20090103022401.GA6778@thyme.bj.intel.com>
Mail-Followup-To: Tino Keitel <tino.keitel@gmx.de>,
	linux-kernel@vger.kernel.org, gregkh@suse.de,
	linux-usb@vger.kernel.org
References: <20090101160343.GA4278@thyme.bj.intel.com> <20090102095643.GB17103@x61> <495E37BC.1040101@rtr.ca> <495E37E9.80903@rtr.ca> <20090102181538.GA26389@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102181538.GA26389@dose.home.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 07:15:38PM +0100, Tino Keitel wrote:
> The issue I noticed with the WD Passport drives is that the hard disk
> won't spin down with /usr/bin/eject, which is used by HAL if the user
> ejects the device (i.e.  via his desktop environment).  The WD Passport
> drives need to be set into a sleep power condition. Something
> like "sg_start --pc=3 /dev/sdX" needs to be used in this case.
> 
> I just checked hdparm -Y, and this works too.

STOP SCSI command spins down the drive but the device is still `on'.

The only way I found on Linux to shut down it's power is to put it
into `suspend' mode.

-- 
Li, Yan
