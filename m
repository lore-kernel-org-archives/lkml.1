Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbZHGNyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbZHGNyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756178AbZHGNyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:54:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37074 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbZHGNyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:54:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH update x2] PM: Introduce core framework for run-time PM of I/O devices (rev. 13)
Date: Fri, 7 Aug 2009 15:54:47 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908061257490.2937-100000@iolanthe.rowland.org> <200908062353.14822.rjw@sisk.pl> <aec7e5c30908070045t6214ce68kcecdc835c2ab7bff@mail.gmail.com>
In-Reply-To: <aec7e5c30908070045t6214ce68kcecdc835c2ab7bff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908071554.48070.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009, Magnus Damm wrote:
> On Fri, Aug 7, 2009 at 6:53 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM: Introduce core framework for run-time PM of I/O devices (rev. 13)
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
> I've rebased my series of patches to v13. My platform device Runtime
> PM code for SuperH works well with drivers for i2c, uio and fbdev with
> v13. Thank you. I'll post a SuperH specific patch set some time next
> week.
> 
> Anyway, I'm not far from an "Acked-by", but please look at the following series:
> 
> [PATCH 00/05] PM: Runtime PM v13 for Platform Devices 20090807
> 
> Maybe there is some code in there that you can include in v14? Let me know!

I will.

Thanks,
Rafael
