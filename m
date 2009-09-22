Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbZIVUGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbZIVUGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 16:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZIVUGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 16:06:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41575 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZIVUGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 16:06:31 -0400
Date: Tue, 22 Sep 2009 16:06:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] vfs: new FROM_ACCESS flag
Message-ID: <20090922200635.GB28826@infradead.org>
References: <20090921013048.2763.1494.stgit@paris.rdu.redhat.com> <20090922135612.GA17769@infradead.org> <1253640526.2747.7.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253640526.2747.7.camel@dhcp231-106.rdu.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 01:28:46PM -0400, Eric Paris wrote:
> > only using MAY_ACCESS for calles from access() insteaf of introducing
> > a FROM_ACCESS flag and causing lots of naming confusion.
> 
> What would you think of a new, MUST_REVALIDATE_PERMS which will do what
> MAY_ACCESS does today.  MAY_ACCESS would be just for access(2) and would
> be the flag that I use for SELinux?

Yeah, something like this.  I don't like the MUST_REVALIDATE_PERMS name
too much, but unless someone comes up with a better one I can live with
it.

