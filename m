Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbZEFQIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbZEFQIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbZEFQI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:08:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44941 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbZEFQI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:08:28 -0400
Date: Wed, 6 May 2009 17:08:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: linux-next: Tree for May 6 (fs/quota)
Message-ID: <20090506160822.GV8633@ZenIV.linux.org.uk>
References: <20090506172653.2f1bbedd.sfr@canb.auug.org.au> <4A01B54D.90301@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A01B54D.90301@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 09:05:33AM -0700, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090505:
> 
> 
> When
> # CONFIG_QUOTA is not set
> CONFIG_QUOTACTL=y
> CONFIG_XFS_QUOTA=y
> 
> fs/quota/quota.c:163: error: redefinition of 'sync_quota_sb'
> include/linux/quotaops.h:338: error: previous definition of 'sync_quota_sb' was here

All fixed in current for-next in vfs tree (3 patches from Alexander Beregalov).
