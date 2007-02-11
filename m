Return-Path: <linux-kernel-owner+w=401wt.eu-S1750700AbXBKPeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750700AbXBKPeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 10:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750696AbXBKPeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 10:34:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50628 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbXBKPeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 10:34:24 -0500
Subject: Re: -mm merge plans for 2.6.21
From: David Woodhouse <dwmw2@infradead.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>, linux-mips@linux-mips.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <20070210213447.GB9116@linux-mips.org>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	 <1171042535.29713.96.camel@pmac.infradead.org>
	 <20070209134516.2367a7aa.akpm@linux-foundation.org>
	 <1171058342.29713.136.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702091442230.2786@alien.or.mcafeemobile.com>
	 <20070210102205.GB8145@osiris.boeblingen.de.ibm.com>
	 <1171103527.29713.228.camel@pmac.infradead.org>
	 <20070210213447.GB9116@linux-mips.org>
Content-Type: text/plain
Date: Sun, 11 Feb 2007 16:33:41 +0100
Message-Id: <1171208022.16494.5.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-10 at 21:34 +0000, Ralf Baechle wrote:
> Unfortunately struct epoll_event contains a gap so it bets on identical
> padding rules between native and compat ABI and anyway, padding is wasted
> space so the struct members should have been swapped when this structure
> was created.  Oh well, too late. 

Indeed. That was the example I was thinking of when I suggested the "no
new syscalls without _simultaneous_ compat version" rule.

-- 
dwmw2

