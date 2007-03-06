Return-Path: <linux-kernel-owner+w=401wt.eu-S934011AbXCFJVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011AbXCFJVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXCFJVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:21:18 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:26513 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934014AbXCFJVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:21:16 -0500
Subject: Re: [S390] system call cleanup.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20070306072706.GA22458@infradead.org>
References: <20070305224320.GL22630@skybase>
	 <20070306072706.GA22458@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Tue, 06 Mar 2007 10:21:16 +0100
Message-Id: <1173172876.24596.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 07:27 +0000, Christoph Hellwig wrote:
> > +	struct pt_regs *regs = task_pt_regs(current);
> > +	char *filename;
> > +	unsigned long result;
> > +	int rc;
> > +
> > +	filename = getname(compat_ptr(regs->orig_gpr2));
> > +	if (IS_ERR(filename)) {
> > +		result = PTR_ERR(filename);
> >                  goto out;
> 
> The old code here..
> 
> > +	struct pt_regs *regs = task_pt_regs(current);
> >          unsigned long clone_flags;
> >          unsigned long newsp;
> >  	int __user *parent_tidptr, *child_tidptr;
> 
> ..and here..
> 
> > +asmlinkage long sys_clone(void)
> >  {
> > +	struct pt_regs *regs = task_pt_regs(current);
> >          unsigned long clone_flags;
> >          unsigned long newsp;
> >  	int __user *parent_tidptr, *child_tidptr;
> 
> ..and here used spaces instead of tabs, it would be nice to clean this
> up while you're at it.

Will do, thanks for the hint.

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


