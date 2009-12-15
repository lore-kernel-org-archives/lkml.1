Return-Path: <linux-kernel-owner+w=401wt.eu-S1760478AbZLOO70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760478AbZLOO70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760436AbZLOO7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:59:25 -0500
Received: from 007.netroom.de ([194.0.247.207]:10915 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760404AbZLOO7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:59:24 -0500
Message-ID: <4B27A443.6040908@draisberghof.de>
Date: Tue, 15 Dec 2009 15:59:15 +0100
From: Josua Dietze <digidietze@draisberghof.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
CC: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Stefan Seyfried <seife@sphairon.com>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com>	<4B278191.1010009@draisberghof.de> <20091215150137.46bd9817@strolchi.home.s3e.de>
In-Reply-To: <20091215150137.46bd9817@strolchi.home.s3e.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Seyfried schrieb:
 > But given that there is already an "option_zero_cd" parameter in

> usb-storage, it should be easy to massage this into a general "do not
> eject virtual installer media" flag so that people are still able to
> get the windows driver files off their devices should they need to do
> so.
> 
>> I'd like to see these devices removed from unusual_devs.h.
> 
> I'd like them to work with one driver, not two (one in kernel and one
> in userspace).


The more basic arguments that prevailed at the last time such an 
"eject" command was being considered for inclusion into usb-storage 
were:

1. Userspace can obviously react a lot quicker than kernel space to 
new or changed devices popping up.

2. Userspace works with older kernels immediately.

> That's a fundamental difference in opinions, and I fear I'm not the one
> who is going to decice how this will be handled ;)


Neither am I. But the number of known mode-switching USB devices is 
now at around 50. New ones are arriving by the month or even week.

A decision to handle *all of them* in usb-storage would lead to the 
disadvantages pointed out.

A decision to handle just *some of them* can hardly be made 
plausible if there are no immediate technical reasons.

Oh, and in most cases (including your suggestion) there *are* 
already two drivers necessary to make these devices work, 
independent of where the switching is happening ...

> Have fun,

You too!

Josh
-- 
Man is the only creature on earth enabled to take a
warm meal while flying!                      Loriot
