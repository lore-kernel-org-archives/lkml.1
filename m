Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZBPXCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZBPXCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZBPXCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:02:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57912 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZBPXCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:02:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFD] Automatic suspend
Date: Tue, 17 Feb 2009 00:02:36 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0902161736210.21117-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902161736210.21117-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170002.37973.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009, Alan Stern wrote:
> On Mon, 16 Feb 2009, Rafael J. Wysocki wrote:
> 
> > OK, so I think there are two things that user space may be allowed to do as
> > far as putting devices into low power states is concerned:
> > * disable/enable the automatic power management of the device (provided that
> >   the driver supports the automatic PM)
> 
> Set the automatic PM parameters (idle timeout, state to go to, etc.).  

Yes.  I'm not sure about the state part, though.

> And disabling automatic PM altogether (effectively the same as setting
> the idle timeout to infinity).

Yes.

> > * check what power states devices are in.
> 
> What about situations where we want to distinguish between the power 
> state of the device itself and the power state of the link?  For a disk 
> drive we may want to power the link on and off quite a lot, as that 
> has low latency, but spinning the disk up and down takes a long time 
> and so should have a longer idle-time value.

Well, I'm not sure at the moment.

Do you have any suggestions?

Rafael
