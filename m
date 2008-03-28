Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbYC1I7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbYC1I7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 04:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYC1I7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 04:59:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57969 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYC1I7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 04:59:34 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080328020853.GB10722@ZenIV.linux.org.uk> (message from Al Viro
	on Fri, 28 Mar 2008 02:08:53 +0000)
Subject: Re: [patch 5/7] vfs: mountinfo: allow using process root
References: <20080327120619.031944658@szeredi.hu> <20080327122357.850000253@szeredi.hu> <20080328020853.GB10722@ZenIV.linux.org.uk>
Message-Id: <E1JfAQk-0000fo-Mi@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 28 Mar 2008 09:59:22 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Mar 27, 2008 at 01:06:24PM +0100, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Allow /proc/<pid>/mountinfo to use the root of <pid> to calculate
> > mountpoints.
> > 
> >  - move definition of 'struct proc_mounts' to <linux/mnt_namespace.h>
> >  - add the process's namespace and root to this structure
> >  - pass a pointer to 'struct proc_mounts' into seq_operations
> 
> NB: we might want to collect that stuff in one place.  Sharing details
> between proc/base and namespace is not nice and it just got more hairy.

OK.  It needs to be in namespace.c because of namespace_sem.

Miklos
