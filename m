Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbZEZAlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbZEZAlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 20:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbZEZAlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 20:41:07 -0400
Received: from mail.crca.org.au ([67.207.131.56]:39176 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbZEZAlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 20:41:05 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200905260058.54482.rjw@sisk.pl>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905252343.23744.rjw@sisk.pl> <200905260045.33902.oliver@neukum.org>
	 <200905260058.54482.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 26 May 2009 10:42:51 +1000
Message-Id: <1243298571.16743.165.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2009-05-26 at 00:58 +0200, Rafael J. Wysocki wrote:
> On Tuesday 26 May 2009, Oliver Neukum wrote:
> > Am Montag, 25. Mai 2009 23:43:23 schrieb Rafael J. Wysocki:
> > > > Oh, before I forget to mention and you ask - how to know what allowance
> > > > for the drivers? I use a sysfs entry - the user then just needs to see
> > > > what's needed on their first attempt, set up a means of putting that
> > > > value in the sysfs file in future (eg /etc/hibernate/tuxonice.conf) and
> > > > then forget about it.
> > >
> > > OK, this is reasonable.
> > 
> > No, I am afraid it is not. The average user has no clue. Even if that
> > is not the problem, the user never knows for sure he has encountered
> > the worst case.
> 
> OK there, but surely it's better to have a sysfs attribute than a fixed value?
> 
> > If you really have drivers that have exceptionally large memory requirements
> > (eg. you need to copy video ram), you should tell the system through struct
> > driver and do accounting at probe and removal of devices.
> 
> Or perhaps the drivers should allocate memory from a PM notifier (which is
> called before the freezing of tasks) to avoid the problem?

That would work.

Regards,

Nigel

