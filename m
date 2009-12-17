Return-Path: <linux-kernel-owner+w=401wt.eu-S935795AbZLQOgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935795AbZLQOgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 09:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZLQOgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 09:36:37 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:58985 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764811AbZLQOgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 09:36:36 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Josua Dietze <digidietze@draisberghof.de>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
Date: Thu, 17 Dec 2009 15:36:44 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Dan Williams <dcbw@redhat.com>,
       Stefan Seyfried <stefan.seyfried@googlemail.com>,
       linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Stefan Seyfried <seife@sphairon.com>
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <200912171402.42168.oliver@neukum.org> <4B2A3312.104@draisberghof.de>
In-Reply-To: <4B2A3312.104@draisberghof.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912171536.44220.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 17. Dezember 2009 14:33:06 schrieb Josua Dietze:
> > Can storage tell the devices apart so that it knows which ones to leave
> > to the kernel solution and which devices to accept so that udev can
> > issue an eject command?
> 
> If you are thinking about the two specific devices at hand there is 
> no need to tell them apart. Same IDs on plugin, same switching 
> procedure, different IDs on return, different drivers take care.

How do you issue an eject command without a /dev/sgX node?

	Regards
		Oliver
