Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbXHISRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbXHISRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbXHISRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:17:44 -0400
Received: from namei.org ([69.55.235.186]:40602 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751581AbXHISRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:17:43 -0400
Date: Thu, 9 Aug 2007 11:16:31 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] CacheFiles: Permit an inode's security ID to be
 obtained [try #2]
In-Reply-To: <20070809160535.17906.59852.stgit@warthog.cambridge.redhat.com>
Message-ID: <Pine.LNX.4.64.0708091114180.19611@us.intercode.com.au>
References: <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com>
 <20070809160535.17906.59852.stgit@warthog.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, David Howells wrote:

> +	u32 (*inode_get_secid)(struct inode *inode);

To maintain API consistency, please return an int which only acts as an 
error code, and returning the secid via a *u32 function parameter.


- James
-- 
James Morris
<jmorris@namei.org>
