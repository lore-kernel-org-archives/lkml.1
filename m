Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbZLPLmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbZLPLmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 06:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762127AbZLPLmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 06:42:32 -0500
Received: from 007.netroom.de ([194.0.247.207]:8175 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762089AbZLPLmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 06:42:31 -0500
Message-ID: <4B28C798.502@draisberghof.de>
Date: Wed, 16 Dec 2009 12:42:16 +0100
From: Josua Dietze <digidietze@draisberghof.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Stefan Seyfried <stefan.seyfried@googlemail.com>,
       linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Stefan Seyfried <seife@sphairon.com>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <200912151611.08576.oliver@neukum.org> <20091215180300.GF16426@one-eyed-alien.net> <200912161129.27284.oliver@neukum.org>
In-Reply-To: <200912161129.27284.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum schrieb:

> Am Dienstag, 15. Dezember 2009 19:03:00 schrieb Matthew Dharm:
>>> This would break existing systems and thus introduce a regression.
>>> We'd need to go through a feature removal process. For the time being
>>> I see no alternative to Seife's patch, as we cannot introduce ejection
>>> code to another wireless driver and need to support these devices.
>> The right answer here is neither to move the eject code nor to introduce
>> more of it.  New devices should be supported via userspace.
> 
> Usually I would agree, but in this case the vendor reused IDs.
> The legacy kernel space switcher and user space would race.

User space can test for device/interface class (which will 
supposedly change even if the IDs do not) and base it's actions on 
that. It was done before.

Apart from that issue, I can see that there is a problem with a 
device that has worked without "external" handling up to now. 
Unfortunately, I can't think about a clean solution.

Josua
-- 
Man is the only creature on earth enabled to take a
warm meal while flying!                      Loriot
