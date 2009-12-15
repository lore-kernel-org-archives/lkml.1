Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZLOMwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZLOMwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 07:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbZLOMwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 07:52:08 -0500
Received: from 007.netroom.de ([194.0.247.207]:24490 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbZLOMwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 07:52:07 -0500
X-Greylist: delayed 1238 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Dec 2009 07:52:07 EST
Message-ID: <4B278191.1010009@draisberghof.de>
Date: Tue, 15 Dec 2009 13:31:13 +0100
From: Josua Dietze <digidietze@draisberghof.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
CC: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Stefan Seyfried <seife@sphairon.com>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com>
In-Reply-To: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Seyfried schrieb:

> The USB ID claimed by zd1211rw for the fake storage device is
> also in use by other, non-zd1211rw devices (Sphairon Homelink
> 1202). Move the eject of these devices to where it belongs and
> where all the needed infrastructure already exists: usb-storage.


We can do the eject (as other mode switches) in userspace. Previous 
discussions pointed into that direction.

And there is always the question of being able to access the "fake 
CD-ROM" without hacking the kernel.

I'd like to see these devices removed from unusual_devs.h.


Josua Dietze
