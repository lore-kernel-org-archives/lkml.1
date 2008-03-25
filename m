Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYCYOdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYCYOdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYCYOdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:33:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34887 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754153AbYCYOdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:33:23 -0400
Date: Tue, 25 Mar 2008 10:33:22 -0400 (EDT)
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
In-Reply-To: <200803251524.34147.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0803251030220.4838-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Oliver Neukum wrote:

> Am Dienstag, 25. März 2008 15:19:45 schrieb Alan Stern:

> > It's not safe for the PM core to do such things unilaterally.  The 
> > decision to unregister a device should be made by the driver or the 
> > subsystem.
> 
> Why? You can trigger it from user space via sysfs

How can you do that?

>  and in many cases
> suspending to disk will disconnect all devices on a bus,

But these disconnects aren't done by the PM core; they are done by 
individual drivers or subsystems.

> so I'd say a
> failure to resume is just a limited subcase of a device vanishing during
> sleep.

I'll go along with that.  If a device vanishes during sleep, the PM 
core isn't responsible for unregistering it -- the device's subsystem 
is.

Alan Stern

