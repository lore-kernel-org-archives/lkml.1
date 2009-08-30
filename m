Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbZH3Asw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbZH3Asw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 20:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZH3Asv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 20:48:51 -0400
Received: from netrider.rowland.org ([192.131.102.5]:52223 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752898AbZH3Asu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 20:48:50 -0400
Date: Sat, 29 Aug 2009 20:48:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/6] PM: Asynchronous resume of devices
In-Reply-To: <200908291449.57667.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908292043500.26533-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Aug 2009, Rafael J. Wysocki wrote:

> I only wanted to say that the advantage is not really that "big". :-)
> 
> > I must agree, 14 threads isn't a lot.  But at the moment that number is 
> > random, not under your control.
> 
> It's not directly controlled, but there are some interactions between the
> async threads, the main threads and the async framework that don't allow this
> number to grow too much.
> 
> IMO it sometimes is better to allow things to work themselves out, as long as
> they don't explode, than to try to keep everything under strict control.  YMMV.

For testing purposes it would be nice to have a one-line summary for
each device containing a thread ID, start timestamp, end timestamp, and
elapsed time.  With that information you could evaluate the amount of
parallelism and determine where the bottlenecks are.  It would give a
much more detailed picture of the entire process than the total time of
your recent patch 9.

Alan Stern


