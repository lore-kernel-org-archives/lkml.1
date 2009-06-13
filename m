Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbZFMWEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbZFMWEp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 18:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZFMWEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 18:04:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34888 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbZFMWEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 18:04:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Sun, 14 Jun 2009 00:04:41 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906131404160.25619-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906131404160.25619-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906140004.42223.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 June 2009, Alan Stern wrote:
> On Sat, 13 Jun 2009, Rafael J. Wysocki wrote:
> 
> > So, the conclusion seems to be that we should break the recurrence
> > at the point we find an already active device or a device with no parent and
> > let the driver(s) handle the more complicated cases.  Is this correct?
> 
> That's right.

OK

> > BTW, is __device_release_driver() the right place for blocking the run-time PM
> > temporarily during remove?
> 
> It is.

OK

> And for submitting a delayed autosuspend request afterward; we
> may as well try to suspend devices that don't have drivers.

OK, but I'd like to add this functionality if future, when at least one bus
type starts using the framework.

I think I have all of the ducks in a row now, so I'm going to post a cleaned-up
patch in a new thread in a while.

Thanks,
Rafael
