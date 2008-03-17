Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYCQKpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYCQKpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 06:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYCQKpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 06:45:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59920 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYCQKpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 06:45:39 -0400
Date: Mon, 17 Mar 2008 06:45:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alan Cox <alan@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       aviro@redhat.com, drepper@redhat.com, hch@infradead.org,
       sds@tycho.nsa.gov, jmorris@namei.org, mtk.manpages@gmail.com
Subject: Re: [RFC] correct flags to f_mode conversion in __dentry_open
Message-ID: <20080317104537.GA32546@infradead.org>
References: <1205346327.5297.232.camel@localhost.localdomain> <20080315215952.GB18676@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080315215952.GB18676@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2008 at 05:59:52PM -0400, Alan Cox wrote:
> > does 11 really mean and should it really always be mapped to (FMODE_READ
> > | FMODE_WRITE) or should it continue to get mapped to 'no permission?'
> 
> We've always mapped 3 to "no permission" to read or write. It's a linuxism

I've tripped over this recently aswell.  It would for sure be useful
to add a sumbolic O_FOO constant for this magic value '3' and document
it in the manpage.
