Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbZCXI6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbZCXI6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757529AbZCXI56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:57:58 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49488 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414AbZCXI55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:57:57 -0400
Subject: Re: [PATCH] kmemtrace: fix build breakage in befs
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
In-Reply-To: <20090324085658.GG13016@elte.hu>
References: <1237884230.25315.33.camel@penberg-laptop>
	 <20090324085128.GF13016@elte.hu> <1237884846.25315.37.camel@penberg-laptop>
	 <20090324085658.GG13016@elte.hu>
Date: Tue, 24 Mar 2009 10:57:54 +0200
Message-Id: <1237885074.25315.43.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 09:56 +0100, Ingo Molnar wrote:
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > On Tue, 2009-03-24 at 09:51 +0100, Ingo Molnar wrote:
> > > there's another build problem as well, in squashfs, and in key.h:
> > > 
> > >  include/linux/key.h:128: error: field 'sem' has incomplete type
> > >  fs/squashfs/export.c:133: error: implicit declaration of function 'kmalloc'
> > >  fs/squashfs/export.c:143: error: implicit declaration of function 'kfree'
> > > 
> > > And i suspect there's more as well. Is there really no unintrusive 
> > > way to solve this - or do you think the RCU change reduces the 
> > > include file spaghetti?
> > 
> > I don't think there is and yes, I do think the RCU change cleans 
> > up things as well.
> 
> Okay. Note, you'll have to test tip:tracing/kmemtrace explicitly as 
> i had to exclude it from tip:master due to test failures. Will put 
> it back in once fixes arrive :)

That's what I am testing right now. It's just that I am working on an
old laptop where building the kernel takes a looong time.... :-)

