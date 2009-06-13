Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbZFMSIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbZFMSIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 14:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbZFMSII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 14:08:08 -0400
Received: from netrider.rowland.org ([192.131.102.5]:40705 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754683AbZFMSIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 14:08:07 -0400
Date: Sat, 13 Jun 2009 14:08:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re:
 [RFC][PATCH 0/2] PM: Rearrange core suspend code)
In-Reply-To: <200906130106.58464.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906131404160.25619-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Jun 2009, Rafael J. Wysocki wrote:

> So, the conclusion seems to be that we should break the recurrence
> at the point we find an already active device or a device with no parent and
> let the driver(s) handle the more complicated cases.  Is this correct?

That's right.

> BTW, is __device_release_driver() the right place for blocking the run-time PM
> temporarily during remove?

It is.  And for submitting a delayed autosuspend request afterward; we
may as well try to suspend devices that don't have drivers.

Alan Stern

