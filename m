Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbYGUXPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbYGUXPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 19:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbYGUXPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 19:15:36 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:19559 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbYGUXPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 19:15:35 -0400
Date: Mon, 21 Jul 2008 16:14:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: michael@ellerman.id.au
Cc: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci kernel-doc fatal error
Message-Id: <20080721161440.31c97fb8.randy.dunlap@oracle.com>
In-Reply-To: <1216681665.7427.9.camel@localhost>
References: <20080721092718.f15dc1ea.randy.dunlap@oracle.com>
	<1216681665.7427.9.camel@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 09:07:45 +1000 Michael Ellerman wrote:

> On Mon, 2008-07-21 at 09:27 -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix kernel-doc comments so that they don't produce errors.
> > Also cut some extraneous copy-paste text.
> > 
> > Error(linhead//drivers/pci/pci.c:1133): duplicate section name 'Description'
> > Error(linhead//drivers/pci/pci.c:1189): duplicate section name 'Description'
> 
> But now the description lines exceed 80 columns, and with longer

Yes, I'm pretty well aware of that.  :(
This is one of the places where we tolerate that, while not enjoying it.

This is a request that akpm has also made, and it makes some sense, and it's
on my long list of (volunteer) doc work to do...

> function names it's even harder to write a meaningful description in
> under 80 columns.

> Couldn't kerneldoc be modified to accept multiline descriptions? I know
> they're /short/ descriptions, but still.

Well, Documentation/kernel-doc-nano-HOWTO.txt explains how to format the
function description and how to handle long(er) descriptions.

> cheers
> 
> ps. I did look at changing kerneldoc to do that myself, but whereas
> previously I thought I didn't really know perl, now I /know/ I totally
> don't know perl ;)

Yes, I understand that comment.  ;)
That's part of the problem, of course.
I.e., if it were straightforward, it would probably already be done.


> > --- linhead.orig/drivers/pci/pci.c
> > +++ linhead/drivers/pci/pci.c
> > @@ -1123,8 +1123,7 @@ int pci_enable_wake(struct pci_dev *dev,
> >  }
> >  
> >  /**
> > - * pci_prepare_to_sleep - prepare PCI device for system-wide transition into
> > - *                        a sleep state
> > + * pci_prepare_to_sleep - prepare PCI device for system-wide transition into a sleep state
> >   * @dev: Device to handle.
> >   *
> >   * Choose the power state appropriate for the device depending on whether
> > @@ -1181,8 +1180,7 @@ int pci_prepare_to_sleep(struct pci_dev
> >  }
> >
> >  /**
> > - * pci_back_from_sleep - turn PCI device on during system-wide transition into
> > - *                       the working state a sleep state
> > + * pci_back_from_sleep - turn PCI device on during system-wide transition into working state
> >   * @dev: Device to handle.
> >   *
> >   * Disable device's sytem wake-up capability and put it into D0.



---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
