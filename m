Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbXLXB5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbXLXB5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 20:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbXLXB5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 20:57:13 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:10202 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbXLXB5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 20:57:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Va5aJR0dENfD+7v0d9JiNdWvLpPNWKdLQa5lMKmHEiliuUNfI2XzwVQTRsFgxAEBh2+eBu1IHqHTfPbGPGHnreRSdu7Ft/j74njzE2Etb/2pZLGMmr6X+8gVepZDO1boSJyZ2mL11w67WeiU7h+xVqcJ9cMZkVZAqswJH/mZZ9Q=
Message-ID: <476F11EE.7070204@gmail.com>
Date: Mon, 24 Dec 2007 07:27:02 +0530
From: Shourya Sarcar <sarcarsh@gmail.com>
Reply-To: sarcarsh@gmail.com
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Larry Finger <larry.finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>, bcm43xx-dev@lists.berlios.de
Subject: Re: Boot time module loading problem
References: <476D38F9.4090802@gmail.com> <476D567D.3020401@lwfinger.net>	 <476DE108.6030306@gmail.com> <476DFC95.9010904@lwfinger.net>	 <476E2A19.1080205@gmail.com>	 (sfid-20071223_092840_824491_0691F36B)  <1198402827.4058.0.camel@johannes.berg>	 (sfid-20071223_094140_414357_81B4D191) <1198404567.4058.2.camel@johannes.berg> <476E3D6D.1010203@gmail.com> <476EB966.1020304@lwfinger.net>
In-Reply-To: <476EB966.1020304@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> With 2.6.24-rc5, a b43 user reports a problem at bootup. The b43
> module, which should be loaded by the ssb module, fails with the
> following type of message:
> 
> ssb: Sonics Silicon Backplane found on PCI device 0000:0c:00.0 b43:
> disagrees about version of symbol ssb_device_is_enabled b43: Unknown
> symbol ssb_device_is_enabled b43: disagrees about version of symbol
> ssb_pcicore_dev_irqvecs_enable b43: Unknown symbol
> ssb_pcicore_dev_irqvecs_enable b43: disagrees about version of symbol
> ssb_bus_may_powerdown b43: Unknown symbol ssb_bus_may_powerdown
> 
> < and more similar lines....>
> 
> If the user issues the commands
> 
> rmmod ssb; modprobe b43
> 
> then the modules are loaded correctly and the wireless device works.
> 
> What could be causing such a problem?
> 
> Larry
> 

Larry, thanks for pursuing this. I upgraded to 2.6.24-rc6 last night and
I don't see this issue anymore. One might think that the clean remake
solved the problem (which I am pretty sure I did with rc5 as well); but 
still does not explain with 2.6.24-rc5, the module would not load on 
first attempt but then load after the manual:

# rmmod ssb;modprobe b43

Best regards,
Shourya




