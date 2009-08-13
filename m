Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbZHMVJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbZHMVJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 17:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZHMVJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 17:09:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36459 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbZHMVJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:09:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
Date: Thu, 13 Aug 2009 23:10:26 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <Pine.LNX.4.44L0.0908131435490.8368-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908131435490.8368-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908132310.26539.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Alan Stern wrote:
> On Thu, 13 Aug 2009, Rafael J. Wysocki wrote:
> 
> > > If the set of pm_connection objects is reasonably small then the
> > > master_hook and slave_hook aren't needed; you can just read through the
> > > entire list.  Leaving out parent-child connections, which we already
> > > know, would help shrink the set.
> > 
> > Do you mean a global list for the entire system?  I'm not sure if that wouldn't
> > hurt performance (please note that it also affects runtime PM).
> 
> It doesn't have to affect runtime PM.  That is, for runtime PM we can 
> make the bus subsystems responsible for enforcing the dependencies.

Since the runtime PM framework takes the parent-child relationships into
accout, I think it should also follow the "master"-"slave" dependencies if they
are represented at the core level.

Still, at this point the question really is how many off-tree dependencies
there are, because the best way to represent them will follow from that.

Thanks,
Rafael
