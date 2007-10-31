Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbXJaMUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbXJaMUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 08:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbXJaMUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 08:20:40 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:16254 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780AbXJaMUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 08:20:39 -0400
Date: Wed, 31 Oct 2007 13:19:47 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@SteelEye.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: add filter function to groups
Message-ID: <20071031131947.35a521c9@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <47285AF0.1010900@s5r6.in-berlin.de>
References: <1193671019.3383.13.camel@localhost.localdomain>
	<1193676852.2655.21.camel@lov.site>
	<1193677071.3383.56.camel@localhost.localdomain>
	<47261F50.3050901@s5r6.in-berlin.de>
	<1193768743.3321.91.camel@localhost.localdomain>
	<20071031035506.GH14910@kroah.com>
	<20071031104103.13e07d8f@gondolin.boeblingen.de.ibm.com>
	<47285063.1040508@s5r6.in-berlin.de>
	<20071031112039.0b067ce3@gondolin.boeblingen.de.ibm.com>
	<47285AF0.1010900@s5r6.in-berlin.de>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007 11:37:36 +0100,
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> > mask_out() would also imply that the common use case is to have all
> > attributes in the group created and that you need to take action to
> > have an attribute not created.
> 
> Here you have a point.  But James has a point too when he says:
> | We basically want to show capability by which file is present.

Currently, if you register an attribute group, all of the attributes
will show up. I find it more intuitive to have to block some attributes
explicitely if I want to have more control, but the original logic is
fine with me as well, if most people prefer that :)

> Anyway, /if/ the reverse logic is preferred, it shouldn't be called
> "mask_out()" but rather "is_masked()" or "is_hidden()" or the like.

Sure. is_masked() would be fine.

