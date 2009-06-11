Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbZFKVFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbZFKVFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 17:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZFKVFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:05:01 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:54925 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZFKVFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:05:00 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Thu, 11 Jun 2009 23:05:48 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-rc7-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906111433110.4875-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906111433110.4875-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906112305.49232.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 11. Juni 2009 20:36:30 schrieb Alan Stern:
> > Or abstractly any power saving state that does autoresume in hardware.
> > In these cases you know that you can enter a powersaving state that
> > will add X latency.
> >
> > In terms of user space API we'll probably add a way for user space
> > to specify how much latency may be added for power management's sake.
> > If busses are stacked the "latency budget" has to be handled at core
> > level. If furthermore states that allow IO but with additional latency
> > are ignored, the budget will be calculated wrongly.
>
> Okay, fine.  What does this have to do with Rafael's work?  Why does
> setting the status to RPM_SUSPENDED even when a device is not in a
> low-power state preclude handling buses that automatically change their
> power state?

For these cases the tree constraint does not apply.
I think there are devices who can be suspended while children are active
and devices which can not be. This is an attribute of the device and should
be evaluated by the core.

	Regards
		Oliver

