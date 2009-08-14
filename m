Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbZHNRSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbZHNRSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 13:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbZHNRSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 13:18:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40330 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbZHNRSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 13:18:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH update 2x] PM: Introduce core framework for run-time PM of I/O devices (rev. 16)
Date: Fri, 14 Aug 2009 19:19:07 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <200908081625.57333.rjw@sisk.pl> <200908132256.42941.rjw@sisk.pl> <aec7e5c30908140208j1498c134j46bef043f60f6c55@mail.gmail.com>
In-Reply-To: <aec7e5c30908140208j1498c134j46bef043f60f6c55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908141919.07492.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Magnus Damm wrote:
> On Fri, Aug 14, 2009 at 5:56 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM: Introduce core framework for run-time PM of I/O devices (rev. 16)
> >
> > Introduce a core framework for run-time power management of I/O
> > devices.  Add device run-time PM fields to 'struct dev_pm_info'
> > and device run-time PM callbacks to 'struct dev_pm_ops'.  Introduce
> > a run-time PM workqueue and define some device run-time PM helper
> > functions at the core level.  Document all these things.
> >
> > Special thanks to Alan Stern for his help with the design and
> > multiple detailed reviews of the pereceding versions of this patch
> > and to Magnus Damm for testing feedback.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> I've now tested v16 with my SuperH Mobile platform device Runtime PM
> implementation. All seems fine and my patches for patches for drivers
> such as i2c master, fbdev, v4l2 and uio behave as expected.
> 
> Acked-by: Magnus Damm <damm@igel.co.jp>
> 
> The patch "PM: Runtime PM v15 - Platform Device Bus Support" works
> well with v16 and does not need any update.

Thanks for the ACK, but I have one more update to the patch.  Namely, I've
decided to change the return value of the ->runtime_idle() callback to int
as a result of the recent discussion on the PCI runtime PM patch from Matthew.

I'll post the updated patch in a little while.

Thanks,
Rafael
