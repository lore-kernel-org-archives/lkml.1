Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbXIAPjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbXIAPjI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 11:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbXIAPi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 11:38:56 -0400
Received: from canuck.infradead.org ([209.217.80.40]:59646 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbXIAPiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 11:38:55 -0400
Date: Sat, 1 Sep 2007 08:36:44 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       len.brown@intel.com, linux-ide@vger.kernel.org, dz@debian.org,
       minyard@acm.org, j.w.r.degoede@hhs.nl, lm-sensors@lm-sensors.org,
       rlove@rlove.org, bzolnier@gmail.com, dmitry.torokhov@gmail.com,
       mzxreary@0pointer.de, stelian@popies.net, ibm-acpi@hmh.eng.br,
       ambx1@neo.rr.com, gimli@dark-green.com
Subject: Re: [PATCH] drivers/firmware: const-ify DMI API and internals
Message-ID: <20070901153644.GA530@kroah.com>
References: <20070901142719.GA31990@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070901142719.GA31990@havoc.gtf.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2007 at 10:27:19AM -0400, Jeff Garzik wrote:
> 
> commit 457b6eb3bf3341d2e143518a0bb99ffbb8d754c4
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Sat Sep 1 10:16:45 2007 -0400
> 
>     drivers/firmware: const-ify DMI API and internals
>     
>     Three main sets of changes:
>     
>     1) dmi_get_system_info() return value should have been marked const,
>        since callers should not be changing that data.
>     
>     2) const-ify DMI internals, since DMI firmware tables should,
>        whenever possible, be marked const to ensure we never ever write to
>        that data area.
>     
>     3) const-ify DMI API, to enable marking tables const where possible
>        in low-level drivers.
>     
>     And if we're really lucky, this might enable some additional
>     optimizations on the part of the compiler.
>     
>     The bulk of the changes are #2 and #3, which are interrelated.  #1 could
>     have been a separate patch, but it was so small compared to the others,
>     it was easier to roll it into this changeset.


Looks great to me, do you want me to take this through my driver tree?
I'd be glad to do so.

thanks for doing this,

greg k-h
