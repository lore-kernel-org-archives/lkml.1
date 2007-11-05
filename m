Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbXKERox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbXKERox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbXKERop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:44:45 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:25313 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbXKERoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:44:44 -0500
Date: Mon, 5 Nov 2007 18:43:50 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/54] Driver Core: add kobj_attribute handling
Message-ID: <20071105184350.0a1cd957@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1194283540.2174.8.camel@lov.site>
References: <20071102235758.GA9803@kroah.com>
	<1194047972-9850-34-git-send-email-gregkh@suse.de>
	<20071105134203.1c078136@gondolin.boeblingen.de.ibm.com>
	<1194279812.6771.11.camel@lov.site>
	<20071105171133.GD12843@suse.de>
	<1194283540.2174.8.camel@lov.site>
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

On Mon, 05 Nov 2007 18:25:40 +0100,
Kay Sievers <kay.sievers@vrfy.org> wrote:

> > > That should usually be done by default attributes assigned to the ktype.
> > > Do you have a good use case, where people need to create such attributes
> > > individually instead?
> > 
> > The s390 code that was converted to use kobj_attributes :)
> > 
> > These look very useful, I'll go add them to the series unless Kay really
> > objects.
> 
> I just want to hear a good reason to create attributes individually. :)
> Especially in conjunction with kobject_register(), these attributes are
> not available at uevent time, which is really really bad.
> 
> Default attributes just work fine, and have the proper error handling
> built-in. Offering special functions for it, may just encourage people
> to continue this "broken" way of creating attributes.

But where should I specify those default attributes?
kset_create_and_register() sets the ktype to kset_ktype...
