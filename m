Return-Path: <linux-kernel-owner+w=401wt.eu-S1761147AbYDNUtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761147AbYDNUtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYDNUtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:49:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:56512 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbYDNUtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:49:10 -0400
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 8)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080414105522.GA4716@ucw.cz>
References: <200804040111.15255.rjw@sisk.pl>
	 <200804132339.45280.rjw@sisk.pl> <1208124646.6958.61.camel@pasglop>
	 <200804140027.12161.rjw@sisk.pl> <1208126822.6958.63.camel@pasglop>
	 <20080414105522.GA4716@ucw.cz>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 06:45:52 +1000
Message-Id: <1208205952.6958.174.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-14 at 12:55 +0200, Pavel Machek wrote:
> On Mon 2008-04-14 08:47:02, Benjamin Herrenschmidt wrote:
> > 
> > > Well, I'm not sure and I'm not going to introduce the change right now, after
> > > the paches have been included in -mm.
> > > 
> > > That would require quite some changes in the core code that I'd prefer to
> > > avoid for now.  We can do something like this in a separate patch series after
> > > the present one settles down a bit.
> > 
> > I disagree.
> > 
> > Doing it later would introduce yet another major semantic change.
> 
> 'allow load_firmware from prepare that was not allowed before' is not 'major'.

Having user space fully operating is major.

Ben.


