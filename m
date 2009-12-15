Return-Path: <linux-kernel-owner+w=401wt.eu-S1751728AbZLOPK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbZLOPK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZLOPKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:10:55 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:53270 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbZLOPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:10:53 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Josua Dietze <digidietze@draisberghof.de>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
Date: Tue, 15 Dec 2009 16:11:08 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Stefan Seyfried <stefan.seyfried@googlemail.com>,
       linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Stefan Seyfried <seife@sphairon.com>
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <4B278191.1010009@draisberghof.de>
In-Reply-To: <4B278191.1010009@draisberghof.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912151611.08576.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 15. Dezember 2009 13:31:13 schrieb Josua Dietze:
> Stefan Seyfried schrieb:
> 
> > The USB ID claimed by zd1211rw for the fake storage device is
> > also in use by other, non-zd1211rw devices (Sphairon Homelink
> > 1202). Move the eject of these devices to where it belongs and
> > where all the needed infrastructure already exists: usb-storage.
> 
> 
> We can do the eject (as other mode switches) in userspace. Previous 
> discussions pointed into that direction.
> 
> And there is always the question of being able to access the "fake 
> CD-ROM" without hacking the kernel.
> 
> I'd like to see these devices removed from unusual_devs.h.

This would break existing systems and thus introduce a regression.
We'd need to go through a feature removal process. For the time being
I see no alternative to Seife's patch, as we cannot introduce ejection
code to another wireless driver and need to support these devices.

	Regards
		Oliver
