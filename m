Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbYDNAmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbYDNAmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbYDNAmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:42:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:52335 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbYDNAma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:42:30 -0400
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 8)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Nigel Cunningham <ncunningham@crca.org.au>, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200804140207.19340.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0804131916420.3060-100000@netrider.rowland.org>
	 <1208130513.6958.72.camel@pasglop>  <200804140207.19340.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 10:40:31 +1000
Message-Id: <1208133631.6958.85.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Please have a look at this thread:
> http://lkml.org/lkml/2008/3/21/322
> (in short, the reporter sees APM suspend breakage under stress, occuring
> because APM uses our suspending of devices without the freezer).
> 
> It mostly appears to work without the freezer, but that's bacuse no one
> actually does things that might break it.  I don't think we can rely on users
> being so kind to us forever. :-)

As far as I'm concerned, it's yet another case of the freezer papering
over a problem rather than fixing it properly.

If we're going to introduce new callbacks, we should have the right
semantic from day 1 -and- fix those problems, rather than going to the
same old recursive nonsensical arguments and do things to paper over
problems.

Ben.


