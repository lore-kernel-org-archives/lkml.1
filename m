Return-Path: <linux-kernel-owner+w=401wt.eu-S1760616AbYCZQgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616AbYCZQgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbYCZQgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:36:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54904 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756993AbYCZQgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:36:37 -0400
Date: Wed, 26 Mar 2008 12:36:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Introduce new top level
 =?iso-8859-1?q?suspend=09and_hibernation_callbacks?= (rev. 2)
In-Reply-To: <200803261642.29801.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0803261236080.7344-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Oliver Neukum wrote:

> Am Mittwoch, 26. März 2008 15:40:27 schrieb Alan Stern:
> > Remember, the whole purpose of this is to let drivers know when the 
> > system is going to sleep or waking up.  Proper handling of devices is 
> > up to the drivers, not up to the core.
> 
> Then declare these methods void. We cannot introduce methods that deliberately
> ignore errors. Reporting is also better done in the drivers.

That decision is up to Rafael.  Changing the methods to return void is 
okay with me.

Alan Stern

