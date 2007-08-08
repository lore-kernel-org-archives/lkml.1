Return-Path: <linux-kernel-owner+w=401wt.eu-S1763039AbXHHL4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763039AbXHHL4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 07:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761510AbXHHLzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 07:55:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38253 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbXHHLzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 07:55:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] uli526x: Add suspend and resume routines
Date: Wed, 8 Aug 2007 14:05:00 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@mcmartin.ca>
References: <200708052114.01790.rjw@sisk.pl> <20070807160357.d6ea9731.akpm@linux-foundation.org>
In-Reply-To: <20070807160357.d6ea9731.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081405.00778.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 8 August 2007 01:03, Andrew Morton wrote:
> On Sun, 5 Aug 2007 21:14:01 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > +#ifdef CONFIG_PM_SLEEP
> > +
> > +/*
> > + *	Suspend the interface.
> > + */
> > +
> > +static int uli526x_suspend(struct pci_dev *pdev, pm_message_t state)
> 
> Since when did suspend and resume methods become dependent upon CONFIG_PM_SLEEP?
> 
> We have eight thousand implementations of this, all of which presently
> use CONFIG_PM.

Yes, they do, but if CONFIG_PM_SLEEP is not set, they won't be used.

Greetings,
Rafael
