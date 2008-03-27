Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbYC0CyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbYC0CyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 22:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbYC0CyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 22:54:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:42770 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbYC0CyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 22:54:03 -0400
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 4)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>
In-Reply-To: <200803270223.06715.rjw@sisk.pl>
References: <200803262353.30566.rjw@sisk.pl>
	 <200803270054.58546.rjw@sisk.pl> <1206576403.6926.62.camel@pasglop>
	 <200803270223.06715.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 13:52:38 +1100
Message-Id: <1206586358.6926.68.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-27 at 02:23 +0100, Rafael J. Wysocki wrote:
> On Thursday, 27 of March 2008, Benjamin Herrenschmidt wrote:
> > 
> > > > There is absolutely no point getting a second struct anymore.
> > > 
> > > I obviously disagree with that opinion, so please elaborate.
> > 
> > Well, what does it bring you ? Why can't it be one struct ? To save
> > space in the data area ?
> 
> Mostly, but not only that.
> 
> There are users of 'struct pm_ops' that aren't even supposed to define the
> _noirq callbacks (device types and device classes), so I thought it would be
> better to introduce a separate _noirq struct after all.

Make sense... USB has no use of noirq for example.

Ben.


