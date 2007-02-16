Return-Path: <linux-kernel-owner+w=401wt.eu-S1946078AbXBPTJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946078AbXBPTJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946223AbXBPTJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:09:42 -0500
Received: from [198.99.130.12] ([198.99.130.12]:41281 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1946078AbXBPTJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:09:41 -0500
Date: Fri, 16 Feb 2007 14:02:04 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should be accepted
Message-ID: <20070216190204.GB7481@ccure.user-mode-linux.org>
References: <11715068631914-git-send-email-blaisorblade@yahoo.it> <20070214215123.57ef2d4a.akpm@linux-foundation.org> <20070215170154.GA5641@ccure.user-mode-linux.org> <200702152005.56594.blaisorblade@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702152005.56594.blaisorblade@yahoo.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 08:05:56PM +0100, Blaisorblade wrote:
> Jeff, I verified my patch is _almost_ enough for 2.6.18 for fully booting a 
> 32bit UML; on 2.6.18 I had to also add PTRACE_GET/SET_THREAD_AREA (this fix 
> was merged in 2.6.19) to avoid tons of TLS errors.

I'm not seeing that.  With the current set of patches, I have 32-bit UMLs
happily booting on x86_64.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
