Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbZFKPFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbZFKPFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbZFKPF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:05:29 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:56941 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762060AbZFKPF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:05:28 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Thu, 11 Jun 2009 17:06:16 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-rc7-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906111041020.3040-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906111041020.3040-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906111706.16848.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 11. Juni 2009 16:52:03 schrieb Alan Stern:
> > Under this definition all devices behind an inactive link are suspended,
> > because they can't do any I/O.  Which appears to makes sense, because
> > their drivers have to be notified before the link is suspended and the
> > link has to be turned on for the devices to be able to communicate with
> > the CPU and RAM.
> >
> > If this definition is adopted, then it's quite clear that the device can
> > only be suspended if all of its children are suspended and it's always
> > necessary to resume the parent of a device in order to resume the device
> > itself.
>
> Okay, I'll agree to that.  It should be made clear that a device which
> is "suspended" according to this definition is not necessarily in a
> low-power state.  For example, before powering down the link to a disk
> drive you might want the drive's suspend method to flush the drive's
> cache, but it wouldn't have to spin the drive down.

This precludes handling busses that have low power states that are
left automatically. If such links are stacked the management of acceptable
latencies cannot be left to the busses.
An actual example are the link states of USB 3.0

	Regards
		Oliver

