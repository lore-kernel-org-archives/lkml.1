Return-Path: <linux-kernel-owner+w=401wt.eu-S1761687AbXK2Jfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761687AbXK2Jfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 04:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXK2Jfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 04:35:43 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:44059 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbXK2Jfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 04:35:42 -0500
Date: Thu, 29 Nov 2007 10:35:10 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071129103510.5d2fda63@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1196322631.3242.198.camel@lov.site>
References: <20071127230252.GB10038@kroah.com>
	<20071128124545.39ae8070@gondolin.boeblingen.de.ibm.com>
	<1196252582.3242.28.camel@lov.site>
	<20071128164842.70caa396@gondolin.boeblingen.de.ibm.com>
	<1196265468.3242.60.camel@lov.site>
	<20071128171238.1ef5d076@gondolin.boeblingen.de.ibm.com>
	<1196267789.3242.87.camel@lov.site>
	<20071128175108.5a370684@gondolin.boeblingen.de.ibm.com>
	<1196269227.3242.93.camel@lov.site>
	<20071129060821.GF26327@kroah.com>
	<1196322631.3242.198.camel@lov.site>
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

On Thu, 29 Nov 2007 08:50:31 +0100,
Kay Sievers <kay.sievers@vrfy.org> wrote:

> We have ~20 callers of kobject_(un)register(), convert them to
> kobject_init() + kobject_add() + kobject_uevent(), and just delete the
> broken kobject_(un)register() functions from the kobject code.

I find a bit more callers in my tree, but it still isn't too many.

This may also be a good time to evaluate which of those kobjects really
need a uevent. For example, I can imagine that you don't need a uevent
for a directory being created, but only for the objects created in that
directory.
