Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYCZPmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYCZPmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbYCZPma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:42:30 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:55398 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbYCZPm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:42:29 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Introduce new top level =?iso-8859-1?q?suspend=09and_hibernation_callbacks?= (rev. 2)
Date: Wed, 26 Mar 2008 16:42:28 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803261032140.4969-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803261032140.4969-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803261642.29801.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 26. März 2008 15:40:27 schrieb Alan Stern:
> Remember, the whole purpose of this is to let drivers know when the 
> system is going to sleep or waking up.  Proper handling of devices is 
> up to the drivers, not up to the core.

Then declare these methods void. We cannot introduce methods that deliberately
ignore errors. Reporting is also better done in the drivers.

	Regards
		Oliver
