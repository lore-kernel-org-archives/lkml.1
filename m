Return-Path: <linux-kernel-owner+w=401wt.eu-S1751764Ab0AAODT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab0AAODT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 09:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651Ab0AAODS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 09:03:18 -0500
Received: from ns01.unsolicited.net ([69.10.132.115]:2865 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab0AAODR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 09:03:17 -0500
Message-ID: <4B3E0061.4000003@unsolicited.net>
Date: Fri, 01 Jan 2010 14:02:09 +0000
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.33-rc1 - Weird hard hangs when rendering 'some' web-sites
 in 	Firefox
References: <4B2FEE46.5030700@unsolicited.net> <8db1092f1001010540l15c8f671y1f6a4a4417eb450b@mail.gmail.com>
In-Reply-To: <8db1092f1001010540l15c8f671y1f6a4a4417eb450b@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> 2009/12/21 David <david@unsolicited.net>:
>   
>> I'm still not sure whether what I'm seeing here is latent hardware
>> problems, but, as a heads up :-
>>
>>    2.6.32, 2.6.32.2 (and previous kernels) - All OK
>>    2.6.33-rc1 - Machine seems fine, until :-
>>
>> I browse to particular sites (one of which is an internet banking site,
>> so no heavy flash etc.). My machine will (completely and repeatably)
>> hang solid. Nothing showing with netconsole, sshd dead, sysrq dead ...
>> reset button time.
>>
>>     
> I can confirm this. Probably it's related only to wireless
> connections, wired seems be OK. My device is:
> 08:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
> [Golan] Network Connection (rev 02)
>
> Regards
>   

Mine is a wired connection, so it seems unconnected with that. I've
replaced the motherboard here and have had no further problems. There is
now a configuration difference though as I've had to disable radeon kms
(with radeon.modeset=0) for the new on-board graphics.

My guess is that this is radeon related, and I'm going to set-up the old
motherboard in a spare case & see what I can work out.

Cheers
David
