Return-Path: <linux-kernel-owner+w=401wt.eu-S933934AbXCPA3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934AbXCPA3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 20:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992450AbXCPA3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 20:29:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57191 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933934AbXCPA2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 20:28:53 -0400
Date: Fri, 16 Mar 2007 01:31:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Aloni <da-x@monatomic.org>,
       linux-kernel@vger.kernel.org
Subject: Re: thread stacks and strict vm overcommit accounting
Message-ID: <20070316013144.0d81c72d@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0703152258530.9602@blonde.wat.veritas.com>
References: <20070313163320.GA28104@localdomain>
	<20070315110621.9a9defaf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703152021130.21129@blonde.wat.veritas.com>
	<20070315233343.662b019c@lxorguk.ukuu.org.uk>
	<20070315153613.3d2eaf10.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703152258530.9602@blonde.wat.veritas.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > With a typical size as a fuzz factor preaccounted in later kernels.
> > 
> > Where's that done?
> 
> I don't know what Alan is referring to there.

fs/exec.c - we add 20 pages to the stack vma size initially.

> We've no more committed to providing each instance with 8MB of stack,
> than we've committed to providing each instance with RLIMIT_AS of
> address space.  The rlimits are limits, not commitments, surely?

Yes, its just that the C programming language is utterly and
mindbogglingly broken when it comes to resource exhaustion for the stack.

Alan
