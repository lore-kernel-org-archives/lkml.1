Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbZIZQ3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbZIZQ3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 12:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZIZQ3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 12:29:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59845 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbZIZQ3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 12:29:48 -0400
Date: Sat, 26 Sep 2009 12:29:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] VFS: Export dquot_send_warning
Message-ID: <20090926162951.GA12397@infradead.org>
References: <1253708720.6052.289.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253708720.6052.289.camel@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 01:25:20PM +0100, Steven Whitehouse wrote:
> Hi,
> 
> It would be useful to have a generic method of sending quota messages
> to userspace. The dquot code has such a method, but it can only currently
> be used by that code, so I'm wondering whether there would be any objections
> to exporting it so that other (non-dquot) filesystems could use it?
> 
> My proposed (first draft) patch is below,

If you want to use it without the "generic" quotas it needs to move
from dquota.c to quota.c.  And of course a user in the patch series
makes the likelyhood of getting this included muc higher :)

