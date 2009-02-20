Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbZBTKuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbZBTKuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 05:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZBTKuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 05:50:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54063 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZBTKuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 05:50:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFD] Automatic suspend
Date: Fri, 20 Feb 2009 11:49:36 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902192215.18365.rjw@sisk.pl> <Pine.LNX.4.44L0.0902191659020.7953-100000@iolanthe.rowland.org> <d6200be20902191839w1f74a962h30e859c8b2434f59@mail.gmail.com>
In-Reply-To: <d6200be20902191839w1f74a962h30e859c8b2434f59@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902201149.37921.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009, Arve Hjønnevåg wrote:
> On Thu, Feb 19, 2009 at 2:08 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >> > It might have to be platform-specific.  The Android people seem to have a
> >> > pretty good idea of what criteria will work for them.
> >>
> >> I'd really like to know in what situations Androind is supposed to suspend
> >> automatically.
> >
> > It might be better to ask in what situations Android is _not_ supposed
> > to sleep automatically.  In other words, in what situations is a
> > wakelock acquired?  Since the whole system is only a phone, this
> > question should have a reasonably well-defined answer.
> 
> On an android phone, any code that needs to run when the screen is off
> must hold a wakelock (directly or indirectly). In general if an
> application or the system is processing an event that may cause a user
> notification (new email, incoming phone call, alarm, etc.) it needs to
> prevent suspend. But, we also use wakelocks to upload stats or
> download system updates in the background, and for media player or
> (gps) data logging applications.

All of this doesn't seem to require wakelocks acuired from kernel space.
What do you need those wakelocks for?

Rafael
