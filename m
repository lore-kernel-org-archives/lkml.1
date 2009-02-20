Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbZBTUuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbZBTUuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 15:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZBTUuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 15:50:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57297 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZBTUuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 15:50:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFD] Automatic suspend
Date: Fri, 20 Feb 2009 21:49:24 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Arve Hj?nnev?g" <arve@android.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <20090220182213.GA1681@ucw.cz> <20090220182609.GA3289@srcf.ucam.org>
In-Reply-To: <20090220182609.GA3289@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902202149.25990.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009, Matthew Garrett wrote:
> On Fri, Feb 20, 2009 at 07:22:15PM +0100, Pavel Machek wrote:
> >  On Mon 2009-02-16 23:23:30, Matthew Garrett wrote:
> > > On Tue, Feb 17, 2009 at 12:19:38AM +0100, Rafael J. Wysocki wrote:
> > > 
> > > > This, again, seems to be a bit x86-centric. :-)  The Android people are telling
> > > > us that on the hardware they deal with it does make sense to put the entire
> > > > system to sleep even for relatively short periods of time, since the latencies
> > > > involved are not too bad.
> > > 
> > > Arve said that the power state was equivalent in idle and suspend, but 
> > 
> > ...for Arve's hardware. Not all embedded systems are like that, and
> > OLPC / PCs are definitely not like that.
> 
> And PCs have enough latency over suspend/resume that we can't do it 
> automatically in a non-intrusive manner anyway, so runtime pm is more 
> interesting there as well.

Agreed.

Thanks,
Rafael
