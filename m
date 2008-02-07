Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbYBGQY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbYBGQY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbYBGQYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:24:51 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54733 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbYBGQYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:24:50 -0500
To: aneesh.kumar@linux.vnet.ibm.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       serue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080207153315.GB8701@skywalker>
	(aneesh.kumar@linux.vnet.ibm.com)
Subject: Re: [patch 07/10] unprivileged mounts: add sysctl tunable for
	"safe" property
References: <20080205213616.343721693@szeredi.hu> <20080205213705.120219893@szeredi.hu> <20080207153315.GB8701@skywalker>
Message-Id: <E1JN9Xv-0003Ab-5c@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 07 Feb 2008 17:24:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Feb 05, 2008 at 10:36:23PM +0100, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Add the following:
> > 
> >   /proc/sys/fs/types/${FS_TYPE}/usermount_safe
> > 
> 
> 
> There is  /proc/fs/<type>/ already. Since it is file system specific
> shouldn't it go there ?

The problem is exactly that it's filesystem specific, each filesystem
creates it's own stuff there.

Also we have a rule tp not create new things under /proc.  Things
should either go into /sys or into /proc/sys.  And I think a sysctl is
more appropriate for this than something under /sys.

Thanks,
Miklos
