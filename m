Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbZBPHBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbZBPHBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 02:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZBPHBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 02:01:14 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:36959 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZBPHBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 02:01:13 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFD] Automatic suspend
Date: Mon, 16 Feb 2009 08:02:32 +0100
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902160010.16955.rjw@sisk.pl> <20090215164456.34aef7e8@infradead.org>
In-Reply-To: <20090215164456.34aef7e8@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902160802.37321.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday 16 February 2009 01:44:56 schrieb Arjan van de Ven:
> On Mon, 16 Feb 2009 00:10:15 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Hi,
> > 
> > The recent descussion about the Android PM patches sent by Arve shows
> > that there is a need to introduce a mechanism allowing us to:
> > (1) automatically put the system as a whole into a sleep state (eg.
> > suspend to RAM) when it is found to be "idle", where the meaning of
> > "idle" has to be defined too,
> > (2) put given subset of devices into low power states whenever they
> > are not used, without putting the entire system into a sleep state.
> 
> 
> For (2), for me the answer is very obvious:
> 
> The Device Driver needs to make the decision to put the device to sleep.
> There are no ifs and buts about this.
> 
> It's the driver who 
> a) knows if there's any activity, such as open users
> and 
> b) is in the right position to know how to put things to sleep.

I think you need  third option between decides to put to sleep
and refuses to put to sleep. It is probably necessary to let drivers
state that they would want to go along if the whole system goes
to sleep.

> Of course, the subsystem the driver belongs to can provide helpers
> (such as generic activity timeout handlers etc).
> 
> For many cases, the drivers do this today already.
> There are cases where doing this has side effects, mostly in terms of
> latency. It is reasonable to have a general mechanism that provides a

Exactly.

	Regards
		Oliver
