Return-Path: <linux-kernel-owner+w=401wt.eu-S937633AbZAPVo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937633AbZAPVo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 16:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763761AbZAPVoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 16:44:14 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:40742 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763092AbZAPVoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 16:44:13 -0500
Date: Fri, 16 Jan 2009 16:38:33 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] uml: fix a link error
Message-ID: <20090116213833.GA11904@c2.user-mode-linux.org>
References: <20090115194033.GA10926@hack.private> <20090116124158.4364e269.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116124158.4364e269.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 12:41:58PM -0800, Andrew Morton wrote:
> On Thu, 15 Jan 2009 19:40:33 +0000
> Am__rico Wang <xiyou.wangcong@gmail.com> wrote:
> >  #define sys_vm86old sys_ni_syscall
> >  #define sys_vm86 sys_ni_syscall
> > +#define sys_sigprocmask sigprocmask
> >  
> >  #define old_mmap old_mmap_i386
> >  
> 
> For how long has this problem been present?
> 
> Why aren't lots of other people reporting it?

There's no problem AFAICT.

This is just bogus.

As you point out, if sigprocmask were missing, people would have
noticed.  Also, the proposed definition would pull in the libc
system call wrapper, not the UML system call definition.

				Jeff
