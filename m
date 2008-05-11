Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbYEKLaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbYEKLaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 07:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYEKLaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 07:30:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56818 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbYEKLaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 07:30:02 -0400
Date: Sun, 11 May 2008 07:30:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Sparc
Message-ID: <20080511113001.GA29364@infradead.org>
References: <20080511.022819.13047794.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511.022819.13047794.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 02:28:19AM -0700, David Miller wrote:
> 3) Provide a state akin to ->orig_eax on x86 that allows the debugger
>    to control syscall restart properly.
> 
>    This, along with the matching gdb patch, kills about 40 or so gdb
>    testsuite failures on 32-bit and 64-bit sparc.
> 
>    As a result M68K is now the only user of ptrace_signal_deliver(),
>    it's broken the same exact way sparc was, and thus needs similar
>    fixes.

Might be worth telling the m68k folks about it, so that it gets fixed
aswell.
