Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0BICGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 21:06:12 -0500
Received: from mail001.aei.ca ([206.123.6.130]:41397 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab0BICGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 21:06:10 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] Bluetooth: Keep a copy of each HID device's report descriptor.
Date: Mon, 8 Feb 2010 21:06:06 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.32.8-crc; KDE/4.3.5; x86_64; ; )
Cc: Michael Poole <mdpoole@troilus.org>, Bastien Nocera <hadess@hadess.net>,
       Jiri Kosina <jkosina@suse.cz>, "Gunn, Brian" <bgunn@solekai.com>,
       Jiri Kosina <jkosina@suse.cz>, Ping <pinglinux@gmail.com>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz> <87vdebfvfk.fsf@troilus.org> <1265392303.31341.235.camel@localhost.localdomain>
In-Reply-To: <1265392303.31341.235.camel@localhost.localdomain>
MIME-Version: 1.0
Message-Id: <201002082106.06301.edt@aei.ca>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been trying to test Michael's magic mouse drivers against 32.7 (or .8-rc).   Is there a tree
based on .32 with these patches?  If not would it be possible to post the patches to lkml?  I do not
mind sorting out a few conflicts - this thread assume one knows a little more about the process being 
used here than is obvious.

TIA
Ed Tomlinson

On Friday 05 February 2010 12:51:43 Marcel Holtmann wrote:
> Hi Michael,
> 
> > > looks good to me. I just prefer that you do the allocation of the report
> > > descriptor before the HID object:
> > 
> > An updated patch is below.  Sorry for the delay -- inclement weather
> > here got in the way of testing this as quickly as I would have liked.
> > 
> > From e245ef87247f5e257db40c412af7991c9af375ab Mon Sep 17 00:00:00 2001
> > From: Michael Poole <mdpoole@troilus.org>
> > Date: Fri, 5 Feb 2010 12:21:38 -0500
> > Subject: [PATCH] Bluetooth: Keep a copy of each HID device's report descriptor.
> > 
> > The report descriptor is read by user space (via the Service
> > Discovery Protocol), so it is only available during the ioctl
> > to connect.  However, the probe function that needs the
> > descriptor might not be called until a specific module is
> > loaded.  Keep a copy of the descriptor so it is available for
> > later use.
> 
> patch has been applied. Thanks.
> 
> Regards
> 
> Marcel
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
