Return-Path: <linux-kernel-owner+w=401wt.eu-S1760586AbYCZUrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586AbYCZUrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757245AbYCZUrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:47:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40976 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757273AbYCZUrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:47:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Introduce new top level =?iso-8859-1?q?suspend=09and_hibernation_callbacks?= (rev. 2)
Date: Wed, 26 Mar 2008 21:46:38 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Oliver Neukum <oliver@neukum.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803261236080.7344-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803261236080.7344-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803262146.39899.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 26 of March 2008, Alan Stern wrote:
> On Wed, 26 Mar 2008, Oliver Neukum wrote:
> 
> > Am Mittwoch, 26. März 2008 15:40:27 schrieb Alan Stern:
> > > Remember, the whole purpose of this is to let drivers know when the 
> > > system is going to sleep or waking up.  Proper handling of devices is 
> > > up to the drivers, not up to the core.
> > 
> > Then declare these methods void. We cannot introduce methods that deliberately
> > ignore errors. Reporting is also better done in the drivers.
> 
> That decision is up to Rafael.  Changing the methods to return void is 
> okay with me.

But that's not what they currently do, either.

If I change the methods to void and it turns out in the future that it's
better if they return error codes, it will be rather difficult to go back and
change everything.  For this reason, I'd prefer to retain the returning of
error codes.

What exactly do you whink would be wrong with using the error codes to avoid
resuming the children of devices that failed to resume?

Rafael
