Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbXIYTUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbXIYTUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 15:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbXIYTUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 15:20:23 -0400
Received: from vena.lwn.net ([206.168.112.25]:35739 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbXIYTUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 15:20:22 -0400
To: David Howells <dhowells@redhat.com>
Cc: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 04/22] CRED: Request a credential record for a kernel service 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Fri, 21 Sep 2007 15:47:24 BST."
Date: Tue, 25 Sep 2007 13:20:21 -0600
Message-ID: <19445.1190748021@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David,

One little thing I noticed:

> + * @cred_kernel_act_as:
> + *	Set the credentials for a kernel service to act as (subjective context).
> + *	@cred points to the credentials structure to be filled in.
> + *	@service names the service making the request.
> + *	@daemon: A userspace daemon to be used as a base for the context.
> + *	@dentry: A file or dir to be used as a base for the file creation
> + *	  context.
> + *	Return 0 if successful.

The comment describes a "dentry" argument, but the actual function does
not have that argument.

jon

Jonathan Corbet / LWN.net / corbet@lwn.net
