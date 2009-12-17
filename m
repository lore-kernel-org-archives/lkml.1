Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbZLQNCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbZLQNCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 08:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758241AbZLQNC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 08:02:29 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:51085 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbZLQNC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 08:02:28 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
Date: Thu, 17 Dec 2009 14:02:41 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Dan Williams <dcbw@redhat.com>, Josua Dietze <digidietze@draisberghof.de>,
       Stefan Seyfried <stefan.seyfried@googlemail.com>,
       linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Stefan Seyfried <seife@sphairon.com>
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <1260993048.2179.68.camel@localhost.localdomain> <20091216195258.GJ16426@one-eyed-alien.net>
In-Reply-To: <20091216195258.GJ16426@one-eyed-alien.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912171402.42168.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 16. Dezember 2009 20:52:58 schrieb Matthew Dharm:
> > > If this is the case, then the only reasonable answer to is to push the
> > > modeswitch code for both into udev and out of the kernel.  It will take
> > 
> > you mean usb_modeswitch, not udev actually.
> 
> That is correct; I had mis-typed.  Tho, the actual implementation is udev
> calling usb_modeswitch and/or eject.

Can storage tell the devices apart so that it knows which ones to leave
to the kernel solution and which devices to accept so that udev can
issue an eject command?

	Regards
		Oliver
