Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbXKSJ4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbXKSJ4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 04:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbXKSJ4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 04:56:01 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:5856 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbXKSJ4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 04:56:00 -0500
Date: Mon, 19 Nov 2007 10:55:18 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: EIP is at device_shutdown+0x32/0x60
Message-ID: <20071119105518.598a02cf@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071116012211.GA7365@suse.de>
References: <3ae72650711150950k74fdb37eu108bb360a594ffe8@mail.gmail.com>
	<20071115190124.GA29599@suse.de>
	<20071116100930.5A78.Y-GOTO@jp.fujitsu.com>
	<20071116012211.GA7365@suse.de>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0-rc2 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 17:22:11 -0800,
Greg KH <gregkh@suse.de> wrote:

> On Fri, Nov 16, 2007 at 10:13:42AM +0900, Yasunori Goto wrote:
> > > > 
> > > > Care to try this:
> > > >   +       system_kset = kset_create_and_register("system", NULL,
> > > >   +                                              &devices_kset->kobj, NULL);
> > > > 
> > > > We should not join the kset, only use it as a parent.
> > > 
> > > Yes, that fixes the problem for me!
> > > 
> > > Can anyone else verify this?
> > 
> > I confirmed it fixed the problem. :-)
> 
> Thanks for testing, the next -mm should have this fix.

Good, since this fixes things for me on s390 as well.
