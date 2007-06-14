Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbXFNLv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbXFNLv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 07:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbXFNLvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 07:51:20 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:11407 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbXFNLvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 07:51:19 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, gregkh@suse.de, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
In-Reply-To: <1181817533.10064.18.camel@localhost.localdomain>
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <20070613111549.db1fa4d9.akpm@linux-foundation.org>
	 <20070614094128.GF17819@atrey.karlin.mff.cuni.cz>
	 <1181817533.10064.18.camel@localhost.localdomain>
Content-Type: text/plain
Organization: IBM
Date: Thu, 14 Jun 2007 13:47:41 +0200
Message-Id: <1181821661.10064.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 12:38 +0200, holzheu wrote:
> On Thu, 2007-06-14 at 11:41 +0200, Jan Kara wrote:
> >   <snip>
> > 
> > > Your proposal is similar to one I made to some Japanese developers
> > > earlier this year.  I was more modest, proposing that we
> > > 
> > > - add an enhanced printk
> > > 
> > > 	xxprintk(msgid, KERN_ERR "some text %d\n", some_number);
> >   Maybe a stupid idea but why do we want to assign these numbers by hand?
> > I can imagine it could introduce collisions when merging tons of patches
> > with new messages... Wouldn't it be better to compute say, 8-byte hash
> > from the message and use it as it's identifier? We could do this
> > automagically at compile time.
> 
> Of course automatically generated message numbers would be great and
> something like:
> 
> hub.4a5bcd77: Detected some problem.

Sorry, I first read: 8 characters not 8 bytes.

Indeed, "hub.d41d8cd98f00b204: Detected some problem." ... does not look
like very beautiful.

But maybe also 4 bytes would be enough, since the hash only has to be
unique within one component e.g. "hub".

Michael

