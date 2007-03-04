Return-Path: <linux-kernel-owner+w=401wt.eu-S932069AbXCDBJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbXCDBJR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 20:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932080AbXCDBJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 20:09:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:44794 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069AbXCDBJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 20:09:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,245,1170662400"; 
   d="scan'208"; a="203674483:sNHT62638408"
Message-ID: <45EA1C3A.6070303@intel.com>
Date: Sat, 03 Mar 2007 17:09:14 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: castet.matthieu@free.fr
CC: e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: e1000 : link down issues
References: <1168534773.45a66cf58d25e@imp4-g19.free.fr>
In-Reply-To: <1168534773.45a66cf58d25e@imp4-g19.free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

castet.matthieu@free.fr wrote:
> Hi,
> 
> I got a 82566DM e1000 network controller [1] on my motherboard, and most of the
> time the link go down when doing dhcp. [2]
> 
> ifconfig eth0 up -> link become up
> dhclient eth0 -> some packet are transmited and received and the link become
> down.
> 
> 
> 
> I sometimes got e1000_reset: Hardware Error.
> 
> This happen with vanilla 2.6.19 and e1000-7.3.20 drivers.
> 
> This is very anoying because I should do rmmod e1000; modprobe e1000; ifup e1000
> in loop until the link stay up.
> I try forcing speed, duplex and flow control, but nothing solve my issue.
> 
> The device is working fine on windows.
> 
> What should I do ?

Can you check the BIOS and see if AMT2 (Management function) is enabled? If so, 
please disable it there. That might fix your problem. Let me know in either case.

Cheers,

Auke
