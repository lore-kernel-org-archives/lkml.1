Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbYBQVRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbYBQVRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYBQVRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:17:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39482 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbYBQVRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:17:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: Suspend doesn't work when SD card is inserted
Date: Sun, 17 Feb 2008 22:15:36 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <c4e36d110802170300t51e45613t4b45c921377bcfd7@mail.gmail.com>
In-Reply-To: <c4e36d110802170300t51e45613t4b45c921377bcfd7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802172215.36991.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of February 2008, Zdenek Kabelac wrote:
> Hello

Hi,

Thanks for the report.

> I've noticed that my system (T61) doesn't want to suspend when SD card
> is in the card reader slot with 2.6.25-rc2  (no problem when the card
> is outside)
> Also the card is not even mounted, it's just in the slot and suspend locks.
> 2.6.24 worked correctly.
> 
> Bisection games showed this patch as the source of problem:
> 
> 775b64d2b6ca37697de925f70799c710aab5849a is first bad commit
> 
> Hope this helps

Yes, thanks.

Most probably the SD driver does something it's not supposed to do in its
.suspend() or .resume() routine.

I've created the Bugzilla entry at
http://bugzilla.kernel.org/show_bug.cgi?id=10030
for this problem, please add yourself to the CC list in there.

I'll be looking at this problem in the next few days.

Thanks,
Rafael
