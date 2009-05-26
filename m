Return-Path: <linux-kernel-owner+w=401wt.eu-S1760698AbZEZWwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698AbZEZWwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760579AbZEZWvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:51:10 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:41414 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760554AbZEZWvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:51:07 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Wed, 27 May 2009 00:51:35 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: nigel@tuxonice.net, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905260045.33902.oliver@neukum.org> <200905260058.54482.rjw@sisk.pl>
In-Reply-To: <200905260058.54482.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905270051.35831.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 26. Mai 2009 00:58:53 schrieb Rafael J. Wysocki:
> > No, I am afraid it is not. The average user has no clue. Even if that
> > is not the problem, the user never knows for sure he has encountered
> > the worst case.
>
> OK there, but surely it's better to have a sysfs attribute than a fixed
> value?

Maybe I should have been more verbose.

A tunable setting is a race condition in itself. The right amount depends
on the drivers loaded and the devices attached and possibly on the status
of devices. Nothing of this can be determined statically.

You want hibernation to work even if the user has plugged in a new device.
You have to calculate that amount in kernel space.

	Regards
		Oliver

