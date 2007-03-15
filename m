Return-Path: <linux-kernel-owner+w=401wt.eu-S1422983AbXCOWar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422983AbXCOWar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422977AbXCOWar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:30:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54517 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422983AbXCOWap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:30:45 -0400
Date: Thu, 15 Mar 2007 23:33:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Aloni <da-x@monatomic.org>,
       linux-kernel@vger.kernel.org
Subject: Re: thread stacks and strict vm overcommit accounting
Message-ID: <20070315233343.662b019c@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0703152021130.21129@blonde.wat.veritas.com>
References: <20070313163320.GA28104@localdomain>
	<20070315110621.9a9defaf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703152021130.21129@blonde.wat.veritas.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Stack RSS should certainly be included in Committed_AS,
> but RLIMIT_STACK merely limits how big the stack vma may grow to:
> at any moment the stack vma is probably very much smaller,
> and only its current size is accounted in Committed_AS.

With a typical size as a fuzz factor preaccounted in later kernels.

> > > Is this the intended behaviour?
> > 
> > That sounds like a bug to me.
> 
> I'm suspecting it's an oddity rather than a bug.

It is intended behaviour.
