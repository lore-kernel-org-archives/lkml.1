Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYBLTlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYBLTlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYBLTlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:41:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49771 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYBLTlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:41:23 -0500
Date: Tue, 12 Feb 2008 21:16:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212201653.GA8005@one.firstfloor.org>
References: <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <alpine.LFD.1.00.0802120829410.2920@woody.linux-foundation.org> <20080212182024.GA4940@one.firstfloor.org> <20080212102010.d88886f3.akpm@linux-foundation.org> <20080212193451.GE19619@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212193451.GE19619@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 02:34:51PM -0500, Frank Ch. Eigler wrote:
> Hi -
> 
> On Tue, Feb 12, 2008 at 10:20:10AM -0800, Andrew Morton wrote:
> > [...]  Bear in mind that one of the things you do with kgdb is to
> > modify kernel memory [...]
> 
> Just for completeness, keep in mind that one can already 
> do these sorts of things on a batch basis using systemtap:

You don't even need systemtap: it has been always possible with
gdb -write vmlinux /proc/kcore

The only value add of the kgdb stub is really that you can single
step too and do post mortem (although the later works fine using
kdump/crash these days too)

-Andi
