Return-Path: <linux-kernel-owner+w=401wt.eu-S933750AbYCDUOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750AbYCDUOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932463AbYCDUOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:14:17 -0500
Received: from smtpauth13.prod.mesa1.secureserver.net ([64.202.165.37]:56096
	"HELO smtpauth13.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932645AbYCDUOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:14:16 -0500
Message-ID: <47CDAC9D.6020505@seclark.us>
Date: Tue, 04 Mar 2008 15:10:05 -0500
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: iTCO watchdog timer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have new Intel DG33FB mainboard.


Mar  2 20:47:19 joker1 kernel: iTCO_vendor_support: vendor-support=0
Mar  2 20:47:19 joker1 kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver 
v1.02 (26-Jul-2007)
Mar  2 20:47:19 joker1 kernel: iTCO_wdt: Found a ICH9DH TCO device 
(Version=2, TCOBASE=0x0460)
Mar  2 20:47:19 joker1 kernel: iTCO_wdt: initialized. heartbeat=30 sec 
(nowayout=0)
...
Mar  4 14:22:59 joker1 kernel: iTCO_wdt: Unexpected close, not stopping 
watchdog!


I start watchdog.c and then kill it expecting the system to reboot - but 
it doesn't.

Isn't this how it is supposed to work?

Linux version 2.6.23.15-137.fc8


Thanks,
Steve


-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



