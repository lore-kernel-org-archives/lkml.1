Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbZCDUmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbZCDUmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbZCDUmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:42:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbZCDUmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:42:06 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Martin Michlmayr <tbm@cyrius.com>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org
Subject: Re: "x86-64: seccomp: fix 32/64 syscall hole" breaks mips
In-Reply-To: Martin Michlmayr's message of  Wednesday, 4 March 2009 21:27:46 +0100 <20090304202746.GA28981@deprecation.cyrius.com>
References: <20090304202746.GA28981@deprecation.cyrius.com>
Emacs: because idle RAM is the Devil's playground.
Message-Id: <20090304204053.175BEFC3BF@magilla.sf.frob.com>
Date: Wed,  4 Mar 2009 12:40:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The change "x86-64: seccomp: fix 32/64 syscall hole" breaks compilation on
> MIPS (and possibly other architectures):

That's what Linus asked for.  
He wants you to define is_compat_task() in asm/compat.h.


Thanks,
Roland
