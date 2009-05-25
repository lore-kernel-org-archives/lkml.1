Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZEYWpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZEYWpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZEYWpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:45:07 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:58366 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbZEYWpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:45:06 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Tue, 26 May 2009 00:45:33 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: nigel@tuxonice.net, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <1243245907.16743.101.camel@nigel-laptop> <200905252343.23744.rjw@sisk.pl>
In-Reply-To: <200905252343.23744.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260045.33902.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 25. Mai 2009 23:43:23 schrieb Rafael J. Wysocki:
> > Oh, before I forget to mention and you ask - how to know what allowance
> > for the drivers? I use a sysfs entry - the user then just needs to see
> > what's needed on their first attempt, set up a means of putting that
> > value in the sysfs file in future (eg /etc/hibernate/tuxonice.conf) and
> > then forget about it.
>
> OK, this is reasonable.

No, I am afraid it is not. The average user has no clue. Even if that
is not the problem, the user never knows for sure he has encountered
the worst case. If you really have drivers that have exceptionally
large memory requirements (eg. you need to copy video ram), you
should tell the system through struct driver and do accounting at
probe and removal of devices.

	Regards
		Oliver

