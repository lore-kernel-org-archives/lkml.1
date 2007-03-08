Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbXCHRAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbXCHRAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbXCHRAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:00:38 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42572 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbXCHRAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:00:37 -0500
Date: Thu, 8 Mar 2007 11:00:01 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 1/6] integrity: new hooks
Message-ID: <20070308170001.GA17304@sergelap.austin.ibm.com>
References: <1173369800.5981.1.camel@localhost.localdomain> <20070308163118.GK6602@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308163118.GK6602@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chris Wright (chrisw@sous-sol.org):
> * Mimi Zohar (zohar@linux.vnet.ibm.com) wrote:
> > +static int dummy_inode_setxattr(struct dentry *dentry, char *name, void *value,
> > +				size_t size, int flags)
> > +{
> > +	if (!strncmp(name, XATTR_SECURITY_PREFIX,
> > +		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
> > +	    !capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +	return 0;
> > +}
> 
> Hold on, what is all this?  Duplication of all of this code is a no go.

It's unfortunate, agreed, but

use of LSM as an integrity framework was also a no-go.

Options?

thanks,
-serge
