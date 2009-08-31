Return-Path: <linux-kernel-owner+w=401wt.eu-S1752065AbZHaOJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbZHaOJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 10:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbZHaOJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 10:09:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56711 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750929AbZHaOJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 10:09:53 -0400
Date: Mon, 31 Aug 2009 10:09:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 10] PM: Measure suspend and resume times for individual
 devices (was: Re: [PATCH 2/6] PM: Asynchronous resume of devices)
In-Reply-To: <200908302313.52945.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908311006490.10295-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Aug 2009, Rafael J. Wysocki wrote:

> > > For testing purposes it would be nice to have a one-line summary for
> > > each device containing a thread ID, start timestamp, end timestamp, and
> > > elapsed time.  With that information you could evaluate the amount of
> > > parallelism and determine where the bottlenecks are.  It would give a
> > > much more detailed picture of the entire process than the total time of
> > > your recent patch 9.
> > 
> > Of course it would.  I think I'll implement it.
> 
> OK, below is a patch for that.  It only prints the time elapsed, because the
> timestamps themselves can be obtained from the usual kernel timestamping.

Does that include the start timestamps?  I don't see them anywhere in
the patch.  Without the start timestamps we have no way to know how
much time was spent waiting for dpm_list_mtx or other resources as
opposed to actually carrying out the operation.

Alan Stern


