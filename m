Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYDMXu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYDMXu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYDMXus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:50:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:40772 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbYDMXus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:50:48 -0400
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
In-Reply-To: <200804140133.23781.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0804131916420.3060-100000@netrider.rowland.org>
	 <200804140133.23781.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 09:49:08 +1000
Message-Id: <1208130548.6958.74.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-14 at 01:33 +0200, Rafael J. Wysocki wrote:
> 
> Plus in my opinion, while with ->prepare() after the freezer it's
> possible
> to write ->prepare() and ->suspend() that will work just fine when we
> remove
> the freezer, with ->prepare() before the freezer it would be hard to
> do that,
> unless ->prepare() was trivial.

And removing a good half of the usage scenario where prepare is useful..

Ben.


