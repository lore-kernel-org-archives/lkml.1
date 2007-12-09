Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbXLIAGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbXLIAGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 19:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbXLIAF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 19:05:56 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:54022 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753051AbXLIAF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 19:05:56 -0500
Date: Sun, 9 Dec 2007 01:05:54 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Mike Houston <mikeserv@bmts.com>
Cc: linux-kernel@vger.kernel.org, mhoffman@lightlink.com,
       lm-sensors@lm-sensors.org
Subject: Re: 2.6.24-rc4 hwmon it87 probe fails
Message-ID: <20071209000554.GF20441@stusta.de>
References: <20071204215154.7f26285e.mikeserv@bmts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071204215154.7f26285e.mikeserv@bmts.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 09:51:54PM -0500, Mike Houston wrote:
> I finally got around to testing Linux 2.6.24 (2.6.24-rc4) and found
> that the it87 driver fails to probe and consequently, my sensors no
> longer work. This was fine with Linux 2.6.23.8 (the last kernel I was
> using)
> 
> The necessary modules load, but:
> 
> it87: Found IT8718F chip at 0x290, revision 2
> it87: in3 is VCC (+5V)
> it87 it87.656: Failed to request region 0x290-0x297
> it87: probe of it87.656 failed with error -16
> 
> Coretemp still works.
> 
> It appears it has something to do with the ioport range being
> reserved for some reason:
> 
> system 00:01: ioport range 0x290-0x29f has been reserved
> 
> At least I don't see that happening on previous kernels.
> 
> In any case, the changes to it87.c itself don't appear to have caused
> this. (CC'd hwmon maintainer anyways, my apologies if that was
> inappropriate)
> 
> dmesg:
> http://www.mikeserv.com/temp/dmesg-2.6.24-rc4.txt
> 
> config:
> http://www.mikeserv.com/temp/config-2.6.24-rc4.txt

Thanks for your report.

Please also provide:
- dmesg from 2.6.23.8
- The output of "cat /proc/ioports" for both kernels

> Thanks for any help or suggestions,
> 
> Mike Houston

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

