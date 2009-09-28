Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbZI1NPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbZI1NPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 09:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZI1NPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 09:15:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbZI1NPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 09:15:13 -0400
Subject: Re: [RFC] VFS: Export dquot_send_warning
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <20090928130951.GB25880@infradead.org>
References: <1253708720.6052.289.camel@localhost.localdomain>
	 <20090926162951.GA12397@infradead.org>
	 <1254122780.6052.365.camel@localhost.localdomain>
	 <20090928130951.GB25880@infradead.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 28 Sep 2009 14:15:07 +0100
Message-Id: <1254143707.6052.442.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-09-28 at 09:09 -0400, Christoph Hellwig wrote:
> On Mon, Sep 28, 2009 at 08:26:20AM +0100, Steven Whitehouse wrote:
> > > If you want to use it without the "generic" quotas it needs to move
> > > from dquota.c to quota.c.  And of course a user in the patch series
> > > makes the likelyhood of getting this included muc higher :)
> > > 
> > 
> > Yes, I have a patch to make use of this from GFS2 though I didn't sent
> > it in the first instance as its trivial and I was more worried about the
> > generic idea being acceptable. Anyway, I'll send an updated patch,
> > including moving/renaming where required, shortly,
> 
> Ok, if you want to be nice send a patch for XFS, too.  Any I really want
> to exercise this functionality in XFSQA as it feels a bit fragile to me.
> Does anyone know about an example userspace client for the
> notifications?
> 
Yes, I'll look at the other filesystems too, but I wanted to be
reasonably sure that it would be ok first. I've got an updated patch
which I'll send shortly.

There is a userspace client in the quota tools called quota_nld but at
the moment its refusing to build for me... looks like some version issue
wrt to the netlink library that its using. Otherwise I'll write my
own :-)

Steve.


