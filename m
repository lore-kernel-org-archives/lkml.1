Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbXKSHaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbXKSHaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 02:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbXKSHa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 02:30:27 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:42585 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbXKSHa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 02:30:26 -0500
Date: Mon, 19 Nov 2007 08:29:45 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       "Michael Ernst" <mernst@de.ibm.com>, "Greg KH" <greg@kroah.com>
Subject: Re: [patch 1/6] sclp: sysfs interface for SCLP cpi
Message-ID: <20071119082945.1e741eb0@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <3ae72650711160708m1855eb18q3a986998cfd87a3f@mail.gmail.com>
References: <20071116142942.978412023@de.ibm.com>
	<20071116143320.980985765@de.ibm.com>
	<3ae72650711160708m1855eb18q3a986998cfd87a3f@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0-rc1 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007 16:08:21 +0100,
"Kay Sievers" <kay.sievers@vrfy.org> wrote:

> On Nov 16, 2007 3:29 PM, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > +
> > +static decl_subsys(cpi, NULL, NULL);
> > +
> 
> decl_subsys() and all other static kset cruft called "subsys" will be
> gone with 2.6.25.
> The patch series doing this is in -mm, and this patch will need
> (trivial) adaption to the
> new interfaces.

Andrew has this one in his lineup:

http://www.eu.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/broken-out/adapt-sclp_cpi_sysc-to-the-kobject-kset-changes.patch
