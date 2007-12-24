Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbXLXEyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbXLXEyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 23:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbXLXEyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 23:54:03 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:50516 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173AbXLXEyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 23:54:02 -0500
Message-ID: <476F3B68.9040702@lwfinger.net>
Date: Sun, 23 Dec 2007 20:54:00 -0800
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: sarcarsh@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>, bcm43xx-dev@lists.berlios.de
Subject: Re: Boot time module loading problem
References: <476D38F9.4090802@gmail.com> <476D567D.3020401@lwfinger.net>	 <476DE108.6030306@gmail.com> <476DFC95.9010904@lwfinger.net>	 <476E2A19.1080205@gmail.com>	 (sfid-20071223_092840_824491_0691F36B)  <1198402827.4058.0.camel@johannes.berg>	 (sfid-20071223_094140_414357_81B4D191) <1198404567.4058.2.camel@johannes.berg> <476E3D6D.1010203@gmail.com> <476EB966.1020304@lwfinger.net> <476F11EE.7070204@gmail.com>
In-Reply-To: <476F11EE.7070204@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shourya Sarcar wrote:
> Larry Finger wrote:
>> With 2.6.24-rc5, a b43 user reports a problem at bootup. The b43
>> module, which should be loaded by the ssb module, fails with the
>> following type of message:
>>
>> ssb: Sonics Silicon Backplane found on PCI device 0000:0c:00.0 b43:
>> disagrees about version of symbol ssb_device_is_enabled b43: Unknown
>> symbol ssb_device_is_enabled b43: disagrees about version of symbol
>> ssb_pcicore_dev_irqvecs_enable b43: Unknown symbol
>> ssb_pcicore_dev_irqvecs_enable b43: disagrees about version of symbol
>> ssb_bus_may_powerdown b43: Unknown symbol ssb_bus_may_powerdown
>>
>> < and more similar lines....>
>>
>> If the user issues the commands
>>
>> rmmod ssb; modprobe b43
>>
>> then the modules are loaded correctly and the wireless device works.
>>
>> What could be causing such a problem?
>>
>> Larry
>>
> 
> Larry, thanks for pursuing this. I upgraded to 2.6.24-rc6 last night and
> I don't see this issue anymore. One might think that the clean remake
> solved the problem (which I am pretty sure I did with rc5 as well); but
> still does not explain with 2.6.24-rc5, the module would not load on
> first attempt but then load after the manual:
> 
> # rmmod ssb;modprobe b43

Johannes may have been right and that you had a stale initrd. I was going to have you try a 'sudo
mkinitrd', but it is now fixed.

Larry
