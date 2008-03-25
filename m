Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbYCYOYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbYCYOYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbYCYOYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:24:38 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:44490 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbYCYOYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:24:38 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Introduce new top level =?iso-8859-1?q?suspend=09and_hibernation_callbacks?= (rev. 2)
Date: Tue, 25 Mar 2008 15:24:33 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803251011110.4838-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803251011110.4838-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803251524.34147.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 25. März 2008 15:19:45 schrieb Alan Stern:
> On Tue, 25 Mar 2008, Oliver Neukum wrote:
> 
> > Am Dienstag, 25. MÃ¤rz 2008 14:06:15 schrieb Rafael J. Wysocki:
> > > On Tuesday, 25 of March 2008, Oliver Neukum wrote:
> > 
> > > > A device that cannot wake up is unusable. Shouldn't the pm core disconnect()
> > > > such a device?
> 
> It's not safe for the PM core to do such things unilaterally.  The 
> decision to unregister a device should be made by the driver or the 
> subsystem.

Why? You can trigger it from user space via sysfs and in many cases
suspending to disk will disconnect all devices on a bus, so I'd say a
failure to resume is just a limited subcase of a device vanishing during
sleep.

	Regards
		Oliver

