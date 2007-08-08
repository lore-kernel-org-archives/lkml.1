Return-Path: <linux-kernel-owner+w=401wt.eu-S933205AbXHHHxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbXHHHxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbXHHHxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:53:31 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:27203 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbXHHHxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:53:30 -0400
Date: Wed, 8 Aug 2007 09:54:32 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
Message-ID: <20070808095432.4a520735@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <m1bqdifowo.fsf@ebiederm.dsl.xmission.com>
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>
	<m1bqdifowo.fsf@ebiederm.dsl.xmission.com>
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

On Wed, 08 Aug 2007 01:47:51 -0600,
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Cornelia Huck <cornelia.huck@de.ibm.com> writes:
> 
> > My udev failed to create /dev/dasd* so it cannot mount root :( I'm
> > currently trying to find out what causes this, may take some time...
> 
> Oh weird.
> 
> No great surprise that something goofed up given how many
> patches were involved.  Still there shouldn't have been
> any user visible differences in the patchset.
> 
> If you can narrow down which patch caused the problem that would be
> great.

Got it: It's patch 6, the readdir simplification.

(The udev on that guest is ancient (063)...)
