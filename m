Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbZEYW7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbZEYW7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZEYW6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:58:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41140 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbZEYW6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:58:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Tue, 26 May 2009 00:58:53 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: nigel@tuxonice.net, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905252343.23744.rjw@sisk.pl> <200905260045.33902.oliver@neukum.org>
In-Reply-To: <200905260045.33902.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260058.54482.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009, Oliver Neukum wrote:
> Am Montag, 25. Mai 2009 23:43:23 schrieb Rafael J. Wysocki:
> > > Oh, before I forget to mention and you ask - how to know what allowance
> > > for the drivers? I use a sysfs entry - the user then just needs to see
> > > what's needed on their first attempt, set up a means of putting that
> > > value in the sysfs file in future (eg /etc/hibernate/tuxonice.conf) and
> > > then forget about it.
> >
> > OK, this is reasonable.
> 
> No, I am afraid it is not. The average user has no clue. Even if that
> is not the problem, the user never knows for sure he has encountered
> the worst case.

OK there, but surely it's better to have a sysfs attribute than a fixed value?

> If you really have drivers that have exceptionally large memory requirements
> (eg. you need to copy video ram), you should tell the system through struct
> driver and do accounting at probe and removal of devices.

Or perhaps the drivers should allocate memory from a PM notifier (which is
called before the freezing of tasks) to avoid the problem?

Rafael
