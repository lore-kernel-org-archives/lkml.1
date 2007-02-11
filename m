Return-Path: <linux-kernel-owner+w=401wt.eu-S1750742AbXBKRN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750742AbXBKRN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbXBKRN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:13:57 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:55967 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbXBKRN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:13:56 -0500
Date: Sun, 11 Feb 2007 16:09:42 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>, linux-mips@linux-mips.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070211160941.GA20998@linux-mips.org>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <1171042535.29713.96.camel@pmac.infradead.org> <20070209134516.2367a7aa.akpm@linux-foundation.org> <1171058342.29713.136.camel@pmac.infradead.org> <Pine.LNX.4.64.0702091442230.2786@alien.or.mcafeemobile.com> <20070210102205.GB8145@osiris.boeblingen.de.ibm.com> <1171103527.29713.228.camel@pmac.infradead.org> <20070210213447.GB9116@linux-mips.org> <1171208022.16494.5.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171208022.16494.5.camel@shinybook.infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 04:33:41PM +0100, David Woodhouse wrote:

> On Sat, 2007-02-10 at 21:34 +0000, Ralf Baechle wrote:
> > Unfortunately struct epoll_event contains a gap so it bets on identical
> > padding rules between native and compat ABI and anyway, padding is wasted
> > space so the struct members should have been swapped when this structure
> > was created.  Oh well, too late. 
> 
> Indeed. That was the example I was thinking of when I suggested the "no
> new syscalls without _simultaneous_ compat version" rule.

The need for a compat ABI is not always obvious.

  Ralf
