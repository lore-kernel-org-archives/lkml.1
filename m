Return-Path: <linux-kernel-owner+w=401wt.eu-S1762289AbXHHIhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762289AbXHHIhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbXHHIg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:36:58 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:28994 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbXHHIg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:36:57 -0400
Date: Wed, 8 Aug 2007 10:37:59 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
Message-ID: <20070808103759.0850383c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <m17io6foh8.fsf@ebiederm.dsl.xmission.com>
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>
	<m1bqdifowo.fsf@ebiederm.dsl.xmission.com>
	<20070808095432.4a520735@gondolin.boeblingen.de.ibm.com>
	<m17io6foh8.fsf@ebiederm.dsl.xmission.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Aug 2007 01:57:07 -0600,
ebiederm@xmission.com (Eric W. Biederman) wrote:

> > Got it: It's patch 6, the readdir simplification.
> >
> > (The udev on that guest is ancient (063)...)
> 
> Ok.  That is weird.

More weirdness. If I activate another dasd from the repair file
system, /dev/dasdb is created...

Same if I set the card reader online: /dev/vmrdr-0.0.000c is created as
expected.

> Does it depend on the order in which the dentries are returned from
> readdir?

I'd think not.

> Unless I made a really stupid error otherwise the two versions
> of readdir should have the same semantics.

Yes, your patch looks sane. I have no idea why it breaks stuff...
