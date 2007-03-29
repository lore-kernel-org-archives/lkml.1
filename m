Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbXC2OkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbXC2OkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 10:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbXC2OkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 10:40:17 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:49775 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739AbXC2OkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 10:40:15 -0400
Message-ID: <460BCFBE.6020700@gmail.com>
Date: Thu, 29 Mar 2007 16:39:58 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
References: <460B6E4B.3060004@gmail.com> <200703291639.41515.rjw@sisk.pl>
In-Reply-To: <200703291639.41515.rjw@sisk.pl>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 29 Mar 2007 16:39:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki napsal(a):
> On Thursday, 29 March 2007 09:44, Jiri Slaby wrote:
>> Hi,
>>
>> I'm getting this while trying to swsups the machine in -rc5, -rc4 is fine:
>>
>> Disabling non-boot CPUs
>> CPU 1 is now offline
>> SMP alternatives: switching to UP code
>> CPU1 is down
>> swsusp: critical section:
>> swsusp: Need to copy 131380 pages
>> swsusp: Not enough free memory
>> Error -12 suspending
>> Enabling non-boot CPUs ...
>>
>> # cat /sys/power/resume
>> 8:6
>> # cat /proc/swaps
>> Filename                                Type            Size    Used    Priority
>> /dev/sda6                               partition       1004020 0       -1
>>
>> Any other info needed?
> 
> Beats me.  There were no changes that could result in such a thing between
> -rc4 and -rc5, at least not in the swsusp department.
> 
> Could you please try to bisect?

Yes, I will.

>> BTW. is this OK on resume?
>> PM: Writing back config space on device 0000:02:00.0 at offset 1 (was 100006, w
>> iting 100002)
>> pnp: Failed to activate device 00:04.
>> pnp: Failed to activate device 00:05.
>>  usbdev5.3_ep00: PM: resume from 0, parent 5-4 still 2
>>
>> # ll /sys/bus/pnp/devices/00\:0{4,5}/driver
>> lrwxrwxrwx 1 root root 0 2007-03-29 09:16 /sys/bus/pnp/devices/00:04/driver
>> -> ../../../bus/pnp/drivers/i8042 kbd
>> lrwxrwxrwx 1 root root 0 2007-03-29 09:16 /sys/bus/pnp/devices/00:05/driver
>> -> ../../../bus/pnp/drivers/i8042 aux
> 
> Well, I don't think so.

(This is probably not a regression, it's in -rc4 too.)

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
