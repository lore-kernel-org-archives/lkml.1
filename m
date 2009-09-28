Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbZI1NJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbZI1NJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 09:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZI1NJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 09:09:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39910 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbZI1NJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 09:09:47 -0400
Date: Mon, 28 Sep 2009 09:09:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] VFS: Export dquot_send_warning
Message-ID: <20090928130951.GB25880@infradead.org>
References: <1253708720.6052.289.camel@localhost.localdomain> <20090926162951.GA12397@infradead.org> <1254122780.6052.365.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254122780.6052.365.camel@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 08:26:20AM +0100, Steven Whitehouse wrote:
> > If you want to use it without the "generic" quotas it needs to move
> > from dquota.c to quota.c.  And of course a user in the patch series
> > makes the likelyhood of getting this included muc higher :)
> > 
> 
> Yes, I have a patch to make use of this from GFS2 though I didn't sent
> it in the first instance as its trivial and I was more worried about the
> generic idea being acceptable. Anyway, I'll send an updated patch,
> including moving/renaming where required, shortly,

Ok, if you want to be nice send a patch for XFS, too.  Any I really want
to exercise this functionality in XFSQA as it feels a bit fragile to me.
Does anyone know about an example userspace client for the
notifications?

