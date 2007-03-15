Return-Path: <linux-kernel-owner+w=401wt.eu-S933464AbXCONHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464AbXCONHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 09:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933537AbXCONHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 09:07:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53084 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933459AbXCONHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 09:07:11 -0400
Subject: Re: [PATCH] Remove "decl_subsys_name" macro and single usage of it.
From: Kay Sievers <kay.sievers@vrfy.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
In-Reply-To: <Pine.LNX.4.64.0703150630270.23698@localhost.localdomain>
References: <Pine.LNX.4.64.0703011205510.20928@CPE00045a9c397f-CM001225dbafb6>
	 <3ae72650703150322h10882044nbcfdddd4187d31ce@mail.gmail.com>
	 <Pine.LNX.4.64.0703150630270.23698@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 14:08:07 +0100
Message-Id: <1173964087.5099.14.camel@pim.off.vrfy.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+c2hxKyGZpqfpzGw4soEFMzJYkkDsxw5cZWiW
 uWXEqmUyYCNa+KJ5aKyVWVhClQ0K0FjFi+SofvZ+ZYcHYOUHrN
 MYCWrzzAj5spysB9UQvkQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 08:52 -0400, Robert P. J. Day wrote:
> On Thu, 15 Mar 2007, Kay Sievers wrote:
> 
> > On 3/1/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> > >
> > >   Remove the macro "decl_subsys_name" which can be used to declare a
> > > sysfs subsystem, along with the single invocation of it in the source
> > > tree, since there appears to be little value in creating a subsystem
> > > whose subsystem name differs from its structure name.  Everyone else
> > > just uses "decl_subsys".
> >
> > Sometimes you want shorter variable names as the created objects in
> > sysfs, because the 80 columns limit of the kernel source makes long
> > variable names pretty inconvenient.
> > And all these decl_* macros, obviously can't create any names that
> > contain '-', which is pretty annoying. There is also a user in the
> > experimental patches in Greg's tree. Please leave it there for now.
> 
> no problem but that patch *was* based on a suggestion by greg in the
> first place.  i'm guessing he just forgot. :-)

A cleanup of the driver-core source is long overdue, that's why we like
everything that goes away here, that isn't really needed. :)

In the end, we should probably just get rid of the whole "struct
subsystem". We can move the lock to the kset and ditch the whole weird
idea of a "subsystem", which is nothing but a collection of ksets, which
the object model can handle without "struct subsystem" just fine.

Thanks,
Kay

