Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbZI1H01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbZI1H01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 03:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZI1H00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 03:26:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbZI1H00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 03:26:26 -0400
Subject: Re: [RFC] VFS: Export dquot_send_warning
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <20090926162951.GA12397@infradead.org>
References: <1253708720.6052.289.camel@localhost.localdomain>
	 <20090926162951.GA12397@infradead.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 28 Sep 2009 08:26:20 +0100
Message-Id: <1254122780.6052.365.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 2009-09-26 at 12:29 -0400, Christoph Hellwig wrote:
> On Wed, Sep 23, 2009 at 01:25:20PM +0100, Steven Whitehouse wrote:
> > Hi,
> > 
> > It would be useful to have a generic method of sending quota messages
> > to userspace. The dquot code has such a method, but it can only currently
> > be used by that code, so I'm wondering whether there would be any objections
> > to exporting it so that other (non-dquot) filesystems could use it?
> > 
> > My proposed (first draft) patch is below,
> 
> If you want to use it without the "generic" quotas it needs to move
> from dquota.c to quota.c.  And of course a user in the patch series
> makes the likelyhood of getting this included muc higher :)
> 

Yes, I have a patch to make use of this from GFS2 though I didn't sent
it in the first instance as its trivial and I was more worried about the
generic idea being acceptable. Anyway, I'll send an updated patch,
including moving/renaming where required, shortly,

Steve.


