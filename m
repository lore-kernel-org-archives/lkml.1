Return-Path: <linux-kernel-owner+w=401wt.eu-S933164AbZHDReA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164AbZHDReA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 13:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932928AbZHDRd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 13:33:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46866 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933155AbZHDRd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 13:33:56 -0400
Date: Tue, 4 Aug 2009 13:33:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       "dtor@mail.ru" <dtor@mail.ru>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
In-Reply-To: <200908041821.26578.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908041330040.3102-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009, Rafael J. Wysocki wrote:

> Not only that.  I'd like to simplify the design, because IMO using one async
> domain would be much more straightforward than using multiple ones.

> If I understand the async framework correctly, the domains are only used for
> synchronization, ie. if you want to wait for a group of async operations to
> complete, you can put them all into one domain and then call
> async_synchronize_full_domain() to wait for them all together.
> 
> You don't need multiple domains to run multiple things in parallel.

There's a basic confusion going on here.

Rui is using "async domain" to mean a collection of devices which 
will be suspended or resumed serially.  Different domains run in 
parallel.

Rafael is using "async domain" to mean a collection of devices which 
will be suspended or resumed in parallel.  Different domains run 
serially.

Once that is cleared up, you should be able to communicate a little 
better...  :-)

Alan Stern

