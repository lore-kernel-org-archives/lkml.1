Return-Path: <linux-kernel-owner+w=401wt.eu-S1767029AbXDTJBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767029AbXDTJBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 05:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766939AbXDTJBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 05:01:33 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:22469 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767029AbXDTJBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 05:01:31 -0400
Date: Fri, 20 Apr 2007 11:04:11 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Greg K-H <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>,
       <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070420110411.0ad70a13@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070419164911.76884b12@gondolin.boeblingen.de.ibm.com>
References: <20070419152941.7c4b7ff2@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.44L0.0704191019320.3413-100000@iolanthe.rowland.org>
	<20070419164911.76884b12@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 16:49:11 +0200,
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> On Thu, 19 Apr 2007 10:20:51 -0400 (EDT),
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > The patch below, applied on top of Cornelia's changes plus the 
> > kobject_init() patch I posted earlier, actually seems to work.  And it 
> > prevents an oops which I was able to trigger without it.
> 
> Looks nice at first glance. I'll try to test it a bit.

OK, I've tested this a bit (with a silly dummy driver and zfcp with
hacked-back-in unload support) and I haven't encountered any problems
so far. So I second the seems-to-work statement :)
