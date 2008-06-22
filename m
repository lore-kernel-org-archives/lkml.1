Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbYFVTz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbYFVTz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYFVTzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:55:18 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:24712 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbYFVTzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:55:17 -0400
Message-ID: <485EAE21.5090504@msgid.tls.msk.ru>
Date: Sun, 22 Jun 2008 23:55:13 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Ondrej Zary <linux@rainbow-software.org>, Mark Lord <lkml@rtr.ca>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: hdparm -M acoustic management for sata disks?
References: <1214043295.17302.16.camel@localhost> <485D098E.3080109@rtr.ca>	 <1214066456.18959.6.camel@localhost>	 <200806212034.24059.linux@rainbow-software.org> <1214074019.18959.17.camel@localhost>
In-Reply-To: <1214074019.18959.17.camel@localhost>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg wrote:
[]
> Am I guessing right that samsung, hitachi et.al just do have support for
> AAM?

Well, it was a neat surprise to me when I discovered that a newly
purchased - not Seagate which I almost always used - drive has all
the acoustic stuff in place.

ATA device, with non-removable media
	Model Number:       Hitachi HUA721050KLA330
	Firmware Revision:  GK6OA70M
	Recommended acoustic management value: 128, current value: 128
    *	Automatic Acoustic Management feature set
...

And it's indeed more quiet when seeking if acoustic management value
is set to 128, and quite more load when set to 255.  Speed decreases
a bit (I didn't do any measurements), but not much.

Western Digital drives also has acoustic management in place.  At
least some of them.  But I never heard of this stuff present for
Seagate drives - my guess is that those are in a "good" compromise
between speed and loudness already :)

/mjt
