Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbYDMW06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbYDMW06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbYDMW0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:26:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37748 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbYDMW0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:26:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 8)
Date: Mon, 14 Apr 2008 00:27:11 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
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
References: <200804040111.15255.rjw@sisk.pl> <200804132339.45280.rjw@sisk.pl> <1208124646.6958.61.camel@pasglop>
In-Reply-To: <1208124646.6958.61.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140027.12161.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, Benjamin Herrenschmidt wrote:
> 
> > > I don't see the point... On the contrary, prepare() is the pefect place
> > > to implement handshaking with userspace for drivers that need to do so,
> > > such as the DRM.
> > 
> > This _comment_ reflects the current situation, which is that we freeze tasks
> > before a suspend.  When it's no longer necessary to do that, I'll be happy to
> > change this comment.  For now, however, that's not the case.
> 
> Can't we run the freezer after prepare() instead ?

Well, I'm not sure and I'm not going to introduce the change right now, after
the paches have been included in -mm.

That would require quite some changes in the core code that I'd prefer to
avoid for now.  We can do something like this in a separate patch series after
the present one settles down a bit.

Thanks,
Rafael
