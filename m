Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbXD0Azx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbXD0Azx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbXD0Azx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:55:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:20567 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309AbXD0Azp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:55:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,458,1170662400"; 
   d="scan'208";a="79866659"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: W1 printk format warning
Date: Thu, 26 Apr 2007 17:55:43 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201C1D359@azsmsx413.amr.corp.intel.com>
In-Reply-To: <20070426142226.891d2e9a.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: W1 printk format warning
Thread-Index: AceISRlB7LuIupdORvKiFfKxlbSZgwAGwkVQ
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "lkml" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 27 Apr 2007 00:55:43.0935 (UTC) FILETIME=[C8BEFCF0:01C78866]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> On Thu, 26 Apr 2007 22:17:44 +0400 Evgeniy Polyakov
<johnpol@2ka.mipt.ru>
> wrote:
> 
> > On Wed, Apr 25, 2007 at 04:45:09PM -0700, Andrew Morton (akpm@linux-
> foundation.org) wrote:
> > > On Wed, 25 Apr 2007 16:21:04 -0700 Randy Dunlap
<randy.dunlap@oracle.com>
> wrote:
> > >
> > > > in 2.6.21-rc7-mm1.  Are you aware of this?
> > > >
> > > > drivers/w1/w1.c:460: warning: too few arguments for format
> > > >
> > > > 	dev_dbg(&sl->dev, "%s: registering %s as %p.\n",
__func__,
> > > > 		&sl->dev.bus_id[0]);
> > > >
> > >
> > > Yeah, that's because Dan's dev_dbg-check-dev_dbg-arguments.patch
added
> > > printk arg-checking to dev_dbg() and a bunch of bugs got exposed.
I fixed
> > > a few of them.
> >
> > Could you post a full list for w1, if there is only one, here is a
fix.
> >
> 
> There's only the one in w1, I think.  I fixed a few more but I didn't
> actually go looking for more such errors.

Feel free to bug me if there is more fallout that is not otherwise
picked up...

--
Dan
