Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbXK2Jl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbXK2Jl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 04:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbXK2JlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 04:41:20 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:63505 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbXK2JlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 04:41:19 -0500
Date: Thu, 29 Nov 2007 10:41:15 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071129104115.034c3469@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071129060458.GE26327@kroah.com>
References: <20071127230252.GB10038@kroah.com>
	<20071128124545.39ae8070@gondolin.boeblingen.de.ibm.com>
	<20071129060458.GE26327@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 22:04:58 -0800,
Greg KH <greg@kroah.com> wrote:

> > > The uevent function will be called when the uevent is about to be sent to
> > > userspace to allow more environment variables to be added to the uevent.
> > 
> > It may be helpful to mention which uevents are by default created by
> > the kobject core (KOBJ_ADD, KOBJ_DEL, KOBJ_MOVE).
> 
> Is this really needed?

If we go forward with Kay's suggestion of removing kobject_register()
and friends, I guess no.

> > > Often, much of the initialization of a kobject is handled by the layer that
> > > manages the containing kset.  See the sample/kobject/kset-example.c for how
> > > this is usually handled.
> > 
> > Do we also want to mention kobject_rename() and kobject_move(), or are
> > those functions so esoteric that most people don't want to know about
> > them?
> 
> They can be found in the kerneldoc api reference if they are needed :)

OK.
