Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbXCEW7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbXCEW7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbXCEW7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:59:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbXCEW7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:59:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [patch] paravirt: VDSO page is essential
In-Reply-To: Jeremy Fitzhardinge's message of  Monday, 5 March 2007 14:01:43 -0800 <45EC9347.9030009@goop.org>
Emacs: there's a reason it comes with a built-in psychotherapist.
Message-Id: <20070305225859.236021800E5@magilla.sf.frob.com>
Date: Mon,  5 Mar 2007 14:58:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Jan Beulich just posted a patch to do just this - relocate the vdso's
> ELF header.  If that's all that's really required to keep COMPAT_VDSO
> viable under PARAVIRT, then it seems like the way to go.

I found http://marc.theaimsgroup.com/?l=xen-devel&m=117309332600075&w=2 and
that must be the one you meant.  The ELF-grokking form of that is exactly
what I had in mind.  The "find relocs with cmp" scheme is pretty silly, but
also works fine.  It trades tweaky ELF knowledge with tweaky fragile build
methods, but it's all about the same to me.  


Thanks,
Roland
