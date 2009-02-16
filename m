Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZBPX3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZBPX3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZBPX3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:29:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58094 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZBPX3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:29:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFD] Automatic suspend
Date: Tue, 17 Feb 2009 00:28:55 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
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
References: <200902162312.50556.rjw@sisk.pl> <Pine.LNX.4.44L0.0902161736210.21117-100000@netrider.rowland.org> <20090216145655.727cd39c@infradead.org>
In-Reply-To: <20090216145655.727cd39c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170028.57501.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009, Arjan van de Ven wrote:
> On Mon, 16 Feb 2009 17:40:10 -0500 (EST)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On Mon, 16 Feb 2009, Rafael J. Wysocki wrote:
> > 
> > > OK, so I think there are two things that user space may be allowed
> > > to do as far as putting devices into low power states is concerned:
> > > * disable/enable the automatic power management of the device
> > > (provided that the driver supports the automatic PM)
> > 
> > Set the automatic PM parameters (idle timeout, state to go to,
> > etc.). And disabling automatic PM altogether (effectively the same as
> > setting the idle timeout to infinity).
> > 
> 
> shouldn't idle timeout etc be internal to the driver?
> Yes policy preferences / constraints makes sense to communicate,
> actual settings do not. For one they keep changing fast all the time
> anyway.

Usually different devices are handled by the same driver.  I don't really
think the same value will be suitable for all of them, so the users should
at least be able to override the driver default, IMO.

Thanks,
Rafael
