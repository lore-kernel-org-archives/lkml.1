Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbYDMXtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbYDMXtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYDMXtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:49:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:40750 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbYDMXtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:49:09 -0400
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 8)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0804131916420.3060-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0804131916420.3060-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 09:48:33 +1000
Message-Id: <1208130513.6958.72.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-04-13 at 19:23 -0400, Alan Stern wrote:
> 
> Thus, in addition to making all the interface changes implied by the 
> new callbacks, drivers would also have to change the way they
> interact 
> with userspace.  Yes, this will have to be done eventually in any
> case, 
> as the freezer goes away -- but it shouldn't have to be done right
> now.

I disagree. The freezer can already be compiled out and is already not
used on some architectures.

Cheers,
Ben.


