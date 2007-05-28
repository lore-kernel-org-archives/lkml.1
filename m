Return-Path: <linux-kernel-owner+w=401wt.eu-S1760342AbXE1NBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760342AbXE1NBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbXE1NBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:01:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41941 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753409AbXE1NBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:01:30 -0400
Date: Mon, 28 May 2007 15:01:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michael-Luke Jones <mlj28@cam.ac.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Message-ID: <20070528130125.GK18807@elf.ucw.cz>
References: <200705272229.21263.rjw@sisk.pl> <200705272231.54535.rjw@sisk.pl> <6BD5252F-96CD-49D9-86C7-18115294D913@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6BD5252F-96CD-49D9-86C7-18115294D913@cam.ac.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> >Use a hibernation and suspend notifier to disable the firmware  
> >requesting
> >mechanism before a hibernation/suspend and enable it after the  
> >operation.
> >
> >Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > drivers/base/firmware_class.c |   36 ++++++++++++++++++++++++++++++ 
> >++++++
> > 1 file changed, 36 insertions(+)
> 
> I don't like this approach, as I feel that the firmware loading  
> interface should be able to detect if a firmware load request is not  
> being handled, due to absence of userspace / hotplug handler presence.

I don't think that's possible. If hotplug handler needs /dev/foo, but
/dev/foo is not available, it will just block waiting there.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
