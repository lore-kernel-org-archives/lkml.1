Return-Path: <linux-kernel-owner+w=401wt.eu-S1761182AbZFJXOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761182AbZFJXOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 19:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbZFJXOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 19:14:43 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:43000 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbZFJXOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 19:14:42 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Thu, 11 Jun 2009 01:15:30 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906101656100.2589-100000@iolanthe.rowland.org> <200906102331.14267.rjw@sisk.pl>
In-Reply-To: <200906102331.14267.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906110115.30729.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 10. Juni 2009 23:31:13 schrieb Rafael J. Wysocki:
> > > +/**
> > > + * pm_check_children - Check if all children of a device have been
> > > suspended. + * @dev: Device to check.
> > > + *
> > > + * Returns 0 if all children of the device have been suspended or
> > > -EBUSY + * otherwise.
> > > + */
> >
> > We might want to do a runtime suspend even if the device's children
> > aren't already suspended.  For example, you could suspend a link while
> > leaving the device on the other end of the link at full power --
> > especially if powering down the device is slow but changing the link's
> > power level is fast.
>
> Well, this means that the dependencies between devices in the device tree
> are pretty much useless for the run-time PM as far as the core is
> concerned.  In which case, why did you mention them at all?

Some bussystems need this constraint others don't or only for some nodes.
We need a way to communicate this to the core.

	Regards
		Oliver


