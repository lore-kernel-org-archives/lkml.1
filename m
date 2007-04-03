Return-Path: <linux-kernel-owner+w=401wt.eu-S1030325AbXDCPWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030325AbXDCPWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 11:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030332AbXDCPWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 11:22:31 -0400
Received: from mga07.intel.com ([143.182.124.22]:3400 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030325AbXDCPWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 11:22:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,366,1170662400"; 
   d="scan'208"; a="207431298:sNHT25444664"
Message-ID: <46127134.7000108@foo-projects.org>
Date: Tue, 03 Apr 2007 08:22:28 -0700
From: "Kok, Auke" <sofar@foo-projects.org>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
MIME-Version: 1.0
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
CC: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       video4linux-list@redhat.com, Michael Bueker <m.bueker@berlin.de>
Subject: Re: OHCI: USB webcam works, but not on USB Hub
References: <53190.192.54.193.51.1175611316.squirrel@rousalka.dyndns.org>
In-Reply-To: <53190.192.54.193.51.1175611316.squirrel@rousalka.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Apr 2007 15:22:30.0179 (UTC) FILETIME=[E4F80F30:01C77603]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Mailhot wrote:
> Michael Bueker wrote :
> 
>> I'm using a USB Webcam with the gspca driver (from
>> http://mxhaard.free.fr/download.html), which has been working fine with the
>> latest kernels.
> 
> ...
> 
>> Now, I'm writing to this list because one of the followups to that post
>> (http://lists.zerezo.com/spca50x-devs/msg00665.html) states that this is
> due
>> to a problem with the Linux USB layer:
>>> pls file a bug "ohci driver can't handle low+fullspeed devices on the same
>>> root hub" to linux usb devel list.
> 
> Do the gspca driver authors even intend to merge their module in mainline
> anytime soon? This kind of problem if typical of out-of-tree development.

even plugging a gspca-device in a UHCI hub has issues - it doesn't work together 
  with any other device on the HUB the last time I checked.

Having the gspca driver move into the main tree would help a lot though.

Cheers,

Auke
