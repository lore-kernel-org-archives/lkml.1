Return-Path: <linux-kernel-owner+w=401wt.eu-S2992721AbXCBXLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992721AbXCBXLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992720AbXCBXLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:11:09 -0500
Received: from mail.screens.ru ([213.234.233.54]:56884 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992724AbXCBXLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:11:08 -0500
Date: Sat, 3 Mar 2007 02:11:03 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: John Reiser <jreiser@BitWagon.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + fully-honor-vdso_enabled.patch added to -mm tree
Message-ID: <20070302231103.GA249@tv-sign.ru>
References: <20070301175207.GA849@tv-sign.ru> <45E891E6.7090807@BitWagon.com> <45E8A300.9020001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E8A300.9020001@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, Chuck Ebbert wrote:
>
> John Reiser wrote:
> > The value of ->sysenter_return is interpreted in user space by the
> > sysexit instruction; nobody else cares what the value is.  The kernel
> > is not required to provide a good value when vdso_enabled is zero,
> > because the kernel has not told the process that sysenter is valid
> > (by setting AT_SYSINFO.)
> 
> Doesn't matter because a malicious user can still execute sysenter.
> We do have to deal with that somehow, so we have to put something
> safe in there.

Yes, but a malicious user can't make any harm to the system, sysexit
jumps to ->sysenter_return when user_mode() is true, right?

(I am asking because I don't know in details what sysexit does).

Oleg.

