Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbYCYUj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbYCYUj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759973AbYCYUjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:39:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34662 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbYCYUjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:39:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 3)
Date: Tue, 25 Mar 2008 21:39:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <Pine.LNX.4.44L0.0803251111260.4838-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803251111260.4838-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803252139.06591.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 of March 2008, Alan Stern wrote:
> On Mon, 24 Mar 2008, Rafael J. Wysocki wrote:
> 
> > The patch below should address all of your comments above.  It also seems to
> > work.
> > 
> > If it looks good to you, please let me know and I'll repost it in a new thread
> > along with the platform and PCI patches adapted to it.
> 
> I don't see anything else to change.  ACK.

Thanks.

I'd like to fix the problem with dpm_list_mtx vs the disabling of interrupts
you pointed out in the other message, though.

Rafael
