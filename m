Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZEYK2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZEYK2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbZEYK2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:28:24 -0400
Received: from ozlabs.org ([203.10.76.45]:43905 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588AbZEYK2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:28:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] scheduler fixes
Date: Mon, 25 May 2009 16:46:06 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain> <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu>
In-Reply-To: <20090525025353.GA2580@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905251646.06788.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 May 2009 12:23:53 pm Ingo Molnar wrote:
> setup_arch() is one huge function that sets up all architecture
> details at once - but if we split a separate setup_arch_mem() out of
> it, and left the rest in setup_arch (and moved it further down), we
> could remove much of bootmem (especially the ugly uses).

cmdline parsing needs to be available even before mem setup.  I waded
into this earlier and broke almost every arch, but if there's renewed 
enthusiasm I could dig out those patches.

(Search for "arch_get_boot_cmdline()").

Cheers,
Rusty.
