Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbZB0U6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbZB0U6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757016AbZB0U6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:58:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45746 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080AbZB0U6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:58:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFD] Automatic suspend
Date: Fri, 27 Feb 2009 21:58:29 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Oliver Neukum <oliver@neukum.org>,
       "Arve Hj?nnev?g" <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0902270943490.2926-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902270943490.2926-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902272158.31784.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 February 2009, Alan Stern wrote:
> On Fri, 27 Feb 2009, Pavel Machek wrote:
> 
> > 
> > > To summarize, we can:
> > > * Use a refcount such that automatic suspend will only be possible if it's
> > >   equal to zero (but that need not be the only criterion).
> > > * Use a per-device flag in dev_pm_info that will be set whenever the device
> > >   driver increases the refcount and unset whenever the driver decreases the
> > >   refcount.
> > > * Use a per-process flag that will be set whenever the process increases the
> > >   refcount and unset whenever the process decreases the refcount.
> > 
> > Yes, that sounds sane, and that's how reasonable wakelock
> > implementation should look like.
> 
> One small point: If you add a per-device flag and a per-process flag as 
> described above, then drivers and processes must not acquire nested 
> references.
> 
> Obviously this is fixable, but it's worth mentioning...

Yes, it's important to remeber IMO.

Thanks,
Rafael
