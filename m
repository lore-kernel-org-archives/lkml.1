Return-Path: <linux-kernel-owner+w=401wt.eu-S1761310AbZLPK3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310AbZLPK3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761271AbZLPK3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:29:15 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:42320 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbZLPK3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:29:13 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
Date: Wed, 16 Dec 2009 11:29:27 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Josua Dietze <digidietze@draisberghof.de>,
       Stefan Seyfried <stefan.seyfried@googlemail.com>,
       linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Stefan Seyfried <seife@sphairon.com>
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <200912151611.08576.oliver@neukum.org> <20091215180300.GF16426@one-eyed-alien.net>
In-Reply-To: <20091215180300.GF16426@one-eyed-alien.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912161129.27284.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 15. Dezember 2009 19:03:00 schrieb Matthew Dharm:
> > This would break existing systems and thus introduce a regression.
> > We'd need to go through a feature removal process. For the time being
> > I see no alternative to Seife's patch, as we cannot introduce ejection
> > code to another wireless driver and need to support these devices.
> 
> The right answer here is neither to move the eject code nor to introduce
> more of it.  New devices should be supported via userspace.

Usually I would agree, but in this case the vendor reused IDs.
The legacy kernel space switcher and user space would race.

	Regards
		Oliver
