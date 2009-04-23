Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbZDWGkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbZDWGkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZDWGkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:40:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbZDWGkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:40:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: PT_DTRACE && uml
In-Reply-To: Oleg Nesterov's message of  Thursday, 23 April 2009 00:17:26 +0200 <20090422221726.GC22755@redhat.com>
References: <20090330185146.D525AFC3AB@magilla.sf.frob.com>
	<20090408203954.GA26816@redhat.com>
	<20090416204004.GA28013@redhat.com>
	<20090416232430.4DAE4FC3C6@magilla.sf.frob.com>
	<20090420183718.GC32527@redhat.com>
	<20090421011354.4B19EFC3C7@magilla.sf.frob.com>
	<20090421214819.GA22845@redhat.com>
	<20090422032205.B8D39FC3C7@magilla.sf.frob.com>
	<20090422220400.GA22755@redhat.com>
	<20090422221726.GC22755@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090423063949.8DE92FC3C7@magilla.sf.frob.com>
Date: Wed, 22 Apr 2009 23:39:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (cc Jeff Dike)

I've also CC'd the UML hackers' mailing list.

> So, arch/um/ seems to be the only user of PT_DTRACE.
> 
> I do not understand this code at all. It looks as if we can just
> s/PT_DTRACE/TIF_SINGLESTEP/.
> 
> But it can't be that simple?

I don't really understand off hand how UML is using PT_DTRACE either.
But clearly it (or any real arch) that needs a flag for an arch purpose
can use a TIF_* bit instead of touching ->ptrace, and should do that.


Thanks,
Roland
