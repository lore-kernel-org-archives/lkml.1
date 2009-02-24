Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbZBXQg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbZBXQg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbZBXQgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:36:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbZBXQgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:36:19 -0500
Subject: Re: RT scheduling and a way to make a process hang, unkillable
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Corey Hickey <bugfood-ml@fatooh.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, mtk.manpages@gmail.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <874oyj4yiz.fsf@basil.nowhere.org>
References: <20090216120213.GB3925@linux.vnet.ibm.com>
	 <1234787082.30178.3.camel@laptop>
	 <20090216131440.GC3925@linux.vnet.ibm.com>
	 <20090216132014.GD3925@linux.vnet.ibm.com> <4999BC0C.1010304@fatooh.org>
	 <20090217050033.GA10409@linux.vnet.ibm.com>
	 <20090217101542.GB15989@linux.vnet.ibm.com>
	 <1234869339.4744.77.camel@laptop>
	 <20090223114541.GD31277@linux.vnet.ibm.com>
	 <1235390396.4645.87.camel@laptop>
	 <20090224091849.GA18693@linux.vnet.ibm.com>
	 <874oyj4yiz.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Tue, 24 Feb 2009 17:36:05 +0100
Message-Id: <1235493365.4645.2061.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 16:58 +0100, Andi Kleen wrote:
> Dhaval Giani <dhaval@linux.vnet.ibm.com> writes:
> >  		new->euid = euid;
> > Index: linux-2.6/include/asm-generic/errno.h
> > ===================================================================
> > --- linux-2.6.orig/include/asm-generic/errno.h
> > +++ linux-2.6/include/asm-generic/errno.h
> > @@ -106,4 +106,6 @@
> >  #define	EOWNERDEAD	130	/* Owner died */
> >  #define	ENOTRECOVERABLE	131	/* State not recoverable */
> >  
> > +#define ENOTIME		132	/* No time available to run process */
> 
> It's normally not a good idea to add new errnos, because old glibc's
> strerror()s won't know about it.
> 
> There are also so many around that you surely will find an existing
> one which sounds appropiate.

Feel free to suggest one, I've read over all these error thingies
several times and non really stood out.

We tried ENOSPC, but people thought that weird too.

