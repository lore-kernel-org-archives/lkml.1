Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbYDMWLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbYDMWLl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYDMWLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:11:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:44905 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbYDMWLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:11:30 -0400
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 8)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200804132339.45280.rjw@sisk.pl>
References: <200804040111.15255.rjw@sisk.pl>
	 <200804131533.03150.rjw@sisk.pl> <1208120711.6958.52.camel@pasglop>
	 <200804132339.45280.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 08:10:46 +1000
Message-Id: <1208124646.6958.61.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > I don't see the point... On the contrary, prepare() is the pefect place
> > to implement handshaking with userspace for drivers that need to do so,
> > such as the DRM.
> 
> This _comment_ reflects the current situation, which is that we freeze tasks
> before a suspend.  When it's no longer necessary to do that, I'll be happy to
> change this comment.  For now, however, that's not the case.

Can't we run the freezer after prepare() instead ?

Ben.


