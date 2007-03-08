Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbXCHQkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbXCHQkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbXCHQkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:40:05 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:54909 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbXCHQkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:40:03 -0500
Date: Thu, 8 Mar 2007 08:31:18 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 1/6] integrity: new hooks
Message-ID: <20070308163118.GK6602@sequoia.sous-sol.org>
References: <1173369800.5981.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173369800.5981.1.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mimi Zohar (zohar@linux.vnet.ibm.com) wrote:
> +static int dummy_inode_setxattr(struct dentry *dentry, char *name, void *value,
> +				size_t size, int flags)
> +{
> +	if (!strncmp(name, XATTR_SECURITY_PREFIX,
> +		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
> +	    !capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +	return 0;
> +}

Hold on, what is all this?  Duplication of all of this code is a no go.

thanks,
-chris
