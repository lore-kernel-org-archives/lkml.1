Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab0CJOFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:05:36 -0500
Received: from tundra.namei.org ([65.99.196.166]:42487 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab0CJOFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:05:34 -0500
Date: Thu, 11 Mar 2010 01:04:52 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Christoph Hellwig <hch@infradead.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>,
       Alex Elder <aelder@sgi.com>, Chris Mason <chris.mason@oracle.com>,
       a.gruenbacher@computer.org
Subject: Re: [RFC][PATCH 0/2] Correct behavior for listxattr and 'trusted'
 xattrs
In-Reply-To: <20100310114035.GA32219@infradead.org>
Message-ID: <alpine.LRH.2.00.1003110104090.29956@tundra.namei.org>
References: <alpine.LRH.2.00.1003021845310.1594@tundra.namei.org> <20100310114035.GA32219@infradead.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010, Christoph Hellwig wrote:

> Now that everyone felt the consensus is that we need the check I look
> into adding it into XFS, but it seems like we already have that check
> in xfs_xattr_put_listent:
> 
> 	/*
>          * Only show root namespace entries if we are actually allowed to
> 	 * see them.
> 	 */
> 	if ((flags & XFS_ATTR_ROOT) && !capable(CAP_SYS_ADMIN))
> 		return 0;
> 

Looks like I didn't understand what the XFS code was doing.


- James
-- 
James Morris
<jmorris@namei.org>
