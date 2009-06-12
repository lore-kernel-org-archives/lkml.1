Return-Path: <linux-kernel-owner+w=401wt.eu-S1760336AbZFLT4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbZFLT4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 15:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZFLT4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 15:56:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59537 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbZFLT4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 15:56:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Fri, 12 Jun 2009 21:56:14 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906121547490.2862-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906121547490.2862-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906122156.14873.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 June 2009, Alan Stern wrote:
> On Fri, 12 Jun 2009, Rafael J. Wysocki wrote:
> 
> > So, are you suggesting that the core should only check the "all children
> > suspended" condition if special flag is set in dev_pm_info?
> 
> Or rather, check it only if the special flag _isn't_ set.

Where the default is unset, I guess?

But then, what about the resuming of the parents before the device is resumed?
Should the parents be resumed regardless of the flag state?  And if so, what's
the condition for breaking the recurrence?  Surely it's not sufficient to check
if the parent is active, because its parent need not be active if it has this
special flag set.

Best,
Rafael
