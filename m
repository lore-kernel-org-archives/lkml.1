Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbYB2Aj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbYB2Aj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755380AbYB2Ajo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:39:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45378 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbYB2Ajn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:39:43 -0500
Date: Thu, 28 Feb 2008 19:39:37 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Quigley <dpquigl@tycho.nsa.gov>
Cc: Christoph Hellwig <hch@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       casey@schaufler-ca.com, viro@ftp.linux.org.uk,
       trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
Message-ID: <20080229003937.GA16343@infradead.org>
References: <746385.69480.qm@web36611.mail.mud.yahoo.com> <1204227035.31790.207.camel@moss-spartans.epoch.ncsc.mil> <20080228234850.GA25829@infradead.org> <1204243497.2715.24.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204243497.2715.24.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 07:04:57PM -0500, Dave Quigley wrote:
> There are several things here. I've spoken to several people about this
> and the belief I've gotten from most of them is that a recommended
> attribute is how this is to be transported. The NFSv4 spec people will
> probably say that if you want xattr like functionality for NFSv4 use
> named attributes. For us this is not an option since we require
> semantics to label on create/open and the only way we can do this is by
> adding a recommended attribute. The create/open calls in NFSv4 takes a
> list of attributes to use on create as part of the request. I really
> don't see a difference between the security blob and the
> username/groupname that NFSv4 currently uses. Also there is a good
> chance that we will need to translate labels at some point (read future
> work).

Then use the existing side-band protocol and ignore the NFSv4 spec
group.  They're <skip colourful language here> anyway.

> > Wow, that's rude even to someone as direct as me.  Casey is the only
> > other person having an in-tree LSM, and I think his input in this
> > area is important.  But if not I as a VFS person can happily give
> > you my "no" for the current version from the VFS point of view.
> 
> I can only speak for myself but honestly I've only seen Casey act
> confrontational to this idea from the beginning. There is absolutely
> nothing in here that is SELinux specific, tecnically its not even MAC
> specific. I said from the beginning that this was perhaps not the best
> name and we are willing to change it

And changing the name and minor details is exactly what Casey requested.

