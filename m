Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZBPCOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZBPCOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 21:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbZBPCOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 21:14:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:39958 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbZBPCOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 21:14:45 -0500
Subject: Re: [RFD] Automatic suspend
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
In-Reply-To: <20090215164456.34aef7e8@infradead.org>
References: <200902160010.16955.rjw@sisk.pl>
	 <20090215164456.34aef7e8@infradead.org>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 13:12:40 +1100
Message-Id: <1234750360.26036.115.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-15 at 16:44 -0800, Arjan van de Ven wrote:
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

 .../...

I agree with pretty much everything Arjan wrote here.

> Userland should never ever control the state of a device like this
> directly. It should do so by a) closing the device and b) setting
> latency / functional requirements

With the possible exception of things like wifi/bt killswitch or network
or similar where the driver cannot shut the device down without losing
the ability to detect activity (ie, switch your PHY off is nice but you
lose the ability to monitor the link for example).

Cheers,
Ben.

