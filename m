Return-Path: <linux-kernel-owner+w=401wt.eu-S1760958AbXK2GJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958AbXK2GJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 01:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757403AbXK2GI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 01:08:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59858 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbXK2GIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 01:08:55 -0500
Date: Wed, 28 Nov 2007 22:04:58 -0800
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071129060458.GE26327@kroah.com>
References: <20071127230252.GB10038@kroah.com> <20071128124545.39ae8070@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128124545.39ae8070@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 12:45:45PM +0100, Cornelia Huck wrote:
> On Tue, 27 Nov 2007 15:02:52 -0800,
> Greg KH <greg@kroah.com> wrote:
> >  - A kset can provide a set of default attributes that all kobjects that
> >    belong to it automatically inherit and have created whenever a kobject
> >    is registered belonging to the kset.
> 
> Hm, the default attributes are provided by the ktype?

Yes, now fixed.

> > The uevent function will be called when the uevent is about to be sent to
> > userspace to allow more environment variables to be added to the uevent.
> 
> It may be helpful to mention which uevents are by default created by
> the kobject core (KOBJ_ADD, KOBJ_DEL, KOBJ_MOVE).

Is this really needed?

> >  - refcount is the kobject's reference count; it is initialized by kobject_init()
> 
> There is no field called "refcount"; the embedded struct kref kref is
> initialized by kobject_init().

now removed, thanks.

> > Often, much of the initialization of a kobject is handled by the layer that
> > manages the containing kset.  See the sample/kobject/kset-example.c for how
> > this is usually handled.
> 
> Do we also want to mention kobject_rename() and kobject_move(), or are
> those functions so esoteric that most people don't want to know about
> them?

They can be found in the kerneldoc api reference if they are needed :)

thanks,

greg k-h
