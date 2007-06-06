Return-Path: <linux-kernel-owner+w=401wt.eu-S1765559AbXFFOfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765559AbXFFOfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 10:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbXFFOfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 10:35:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43895 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751098AbXFFOfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 10:35:37 -0400
Date: Wed, 6 Jun 2007 10:35:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michael Hanselmann <linux-kernel@hansmi.ch>
cc: linux-kernel@vger.kernel.org, <dbrownell@users.sourceforge.net>,
       <linux-usb-devel@lists.sourceforge.net>,
       <linux-kernel@killerfox.forkbomb.ch>
Subject: Re: [linux-usb-devel] [PATCH] Fix NEC OHCI chip silicon bug
In-Reply-To: <20070606092837.GA19712@hansmi.ch>
Message-ID: <Pine.LNX.4.44L0.0706061034130.3405-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007, Michael Hanselmann wrote:

> > So the system is behaving the way you want, but not for the reason you 
> > think.  I bet you could remove the call to usb_root_hub_lost_power() 
> > entirely and it wouldn't make any difference at all.
> 
> Actually, that's true. René Nussbaumer tried without that call and it
> still works as intended. Should I leave that call out and drop the
> changes on usb_root_hub_lost_power for CONFIG_PM?

That would be best.  usb_root_hub_lost_power() is really meant to be 
used only when resuming from a suspend; it isn't appropriate for your 
situation.

Alan Stern

