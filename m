Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbYDMOFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbYDMOFy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 10:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbYDMOFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 10:05:46 -0400
Received: from www.tglx.de ([62.245.132.106]:34749 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757509AbYDMOFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 10:05:45 -0400
Date: Sun, 13 Apr 2008 16:05:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, sam@ravnborg.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] documentation: build source files in Documentation
 sub-dir
In-Reply-To: <20080410181153.92a5724d.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0804131602310.3261@apollo.tec.linutronix.de>
References: <20080403124529.3f2efb79.randy.dunlap@oracle.com> <20080408134613.a047a7b6.akpm@linux-foundation.org> <20080409123551.42c5da0d.randy.dunlap@oracle.com> <20080409145409.615cd236.akpm@linux-foundation.org> <20080410175630.d862af9e.randy.dunlap@oracle.com>
 <20080410181153.92a5724d.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008, Andrew Morton wrote:
> >  struct ustat {
> > -	__kernel_daddr_t	f_tfree;
> > -	__kernel_ino_t		f_tinode;
> > +	daddr_t			f_tfree;
> > +	ino_t			f_tinode;
> >  	char			f_fname[6];
> >  	char			f_fpack[6];
> >  };
> 
> hm.
> 
> It'd be nice to know how git-x86 managed to make this happen.  I haven't
> looked, apart from noting that it doesn't seem to touch any of the relevant
> files.
 
Hmm, something must define __KERNEL_STRICT_NAMES to make this happen,
but there is nothing in the entire kernel tree which defines it.

Thanks,
	tglx
