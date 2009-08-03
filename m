Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbZHCIKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbZHCIKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 04:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZHCIKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 04:10:55 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:53806 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbZHCIKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 04:10:54 -0400
Date: Mon, 3 Aug 2009 10:10:37 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Christoph Hellwig <hch@infradead.org>, Will Newton <will.newton@gmail.com>,
       dwalker@fifo99.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][patch 02/12] remove clocksource inline functions
Message-ID: <20090803101037.6989b427@skybase>
In-Reply-To: <20746.1249041022@turing-police.cc.vt.edu>
References: <200907291457.n6TEvDAt003701@d06av06.portsmouth.uk.ibm.com>
	<20090729173231.012d0b89@skybase>
	<87a5b0800907290836n6bb6da36tb0124e6d4f0673ea@mail.gmail.com>
	<20090729182754.2361631b@skybase>
	<28082.1248956470@turing-police.cc.vt.edu>
	<20090730214836.GB15780@infradead.org>
	<20746.1249041022@turing-police.cc.vt.edu>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009 07:50:22 -0400
Valdis.Kletnieks@vt.edu wrote:

> On Thu, 30 Jul 2009 17:48:36 EDT, Christoph Hellwig said:
> > > You know that a priori because you're familiar with that code. But there's
> > > another use case: An idiot monkey like myself manages to break the kernel
> > > *again* in some part of the kernel they're totally unfamiliar with, and
> > > they need to discover for themselves that timekeeping.c is the only user.
> > > 
> > > (Of course, in another 5-6 years I'll probably have broken something in
> > > every part of the kernel and whinged at Andrew about it, and that argument
> > > won't apply anymore.. ;)
> > 
> > Andthe poor grepping monkey can be sure that everyone used the useless
> > wrapper exactly how?  If you want to help people with grepping rename
> > the method from read to clocksource_read..
> 
> Even better. ;)
 
With the same reasoning you could argue that f_ops->read should be
renamed to f_ops->file_read. And why is it so important to be able
to grep for clocksource_read? Not that a patch to rename read to
clocksource_read is hard but before I go ahead an do the rename for 60+
clocksources in the kernel I would like to have a better reason than
"I might want to grep it".

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

