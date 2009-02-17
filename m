Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbZBQKLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbZBQKLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZBQKL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:11:28 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:47669 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbZBQKL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:11:27 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFD] Automatic suspend
Date: Tue, 17 Feb 2009 11:12:59 +0100
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <200902170019.40599.rjw@sisk.pl> <20090216232329.GA15678@srcf.ucam.org>
In-Reply-To: <20090216232329.GA15678@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902171113.02114.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tuesday 17 February 2009 00:23:30 schrieb Matthew Garrett:
> On Tue, Feb 17, 2009 at 12:19:38AM +0100, Rafael J. Wysocki wrote:
> 
> > This, again, seems to be a bit x86-centric. :-)  The Android people are telling
> > us that on the hardware they deal with it does make sense to put the entire
> > system to sleep even for relatively short periods of time, since the latencies
> > involved are not too bad.
> 
> Arve said that the power state was equivalent in idle and suspend, but 
> that they preferred suspend because it stopped any periodic timers. I'd 
> be more interested in making sure that unnecessary timers aren't running 
> than focusing on automatically entering system-wide suspend - Nokia have 
> been managing this since 2005 with good results.

I agree. For a general purpose system it would be very hard to call
some timers unnecessary and others necessary.

	Regards
		Oliver

