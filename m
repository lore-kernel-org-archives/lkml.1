Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbXKETAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbXKETAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbXKETAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:00:08 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:35045 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbXKETAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:00:06 -0500
Date: Mon, 5 Nov 2007 19:59:50 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/54] Driver Core: add kobj_attribute handling
Message-ID: <20071105195950.604ea56f@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1194287971.2174.27.camel@lov.site>
References: <20071102235758.GA9803@kroah.com>
	<1194047972-9850-34-git-send-email-gregkh@suse.de>
	<20071105134203.1c078136@gondolin.boeblingen.de.ibm.com>
	<1194279812.6771.11.camel@lov.site>
	<20071105171133.GD12843@suse.de>
	<1194283540.2174.8.camel@lov.site>
	<20071105184350.0a1cd957@gondolin.boeblingen.de.ibm.com>
	<1194286070.2174.14.camel@lov.site>
	<20071105191705.5f2baaaa@gondolin.boeblingen.de.ibm.com>
	<1194287971.2174.27.camel@lov.site>
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

On Mon, 05 Nov 2007 19:39:31 +0100,
Kay Sievers <kay.sievers@vrfy.org> wrote:

> Where are the objects that join this kset? A kset is a "collection of
> objects of a similar type", If there are no objects, you don't need a
> kset at all, I guess, but just a plain directory. :)

Yes, ipl.c looks a lot like "we need a subdirectory under /sys/firmware/
and need to jump through hoops to get it there".

> Anyway, seems we need an easy way to pass default attributes to ksets
> and plain directories. If userspace should set some values here when a
> subsystems creates the its sysfs representation, we must make sure, that
> the attributes exist at the time the event is sent, otherwise we will
> run into all sorts of timing problems.

Maybe they need something like device->uevent_suppress, but at the
kobject level?
