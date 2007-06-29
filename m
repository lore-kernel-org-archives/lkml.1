Return-Path: <linux-kernel-owner+w=401wt.eu-S1766004AbXF2Mk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766004AbXF2Mk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbXF2MkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:40:17 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:21445 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239AbXF2MkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:40:15 -0400
Message-ID: <4684FDAC.7000800@msgid.tls.msk.ru>
Date: Fri, 29 Jun 2007 16:40:12 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Dave Young <hidave.darkstar@gmail.com>,
       Li Yang-r58472 <LeoLi@freescale.com>, Josh Triplett <josh@kernel.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Chris Shoemaker <c.shoemaker@cox.net>,
       Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [OT] Vim highlighting for trailing spaces
References: <46835C16.9020700@kernel.org> <989B956029373F45A0B8AF0297081890D834BE@zch01exm26.fsl.freescale.net> <a8e1da0706280010m1e787bc2jae999084438982da@mail.gmail.com> <a8e1da0706280020ocf81ce7u98de87f16d674706@mail.gmail.com> <7958FF64-140B-435A-8B69-A503C5C18D79@mac.com>
In-Reply-To: <7958FF64-140B-435A-8B69-A503C5C18D79@mac.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> On Jun 28, 2007, at 03:20:24, Dave Young wrote:
>> And for vim trailing space, there's a tip in vim.org:
>> http://www.vim.org/tips/tip.php?tip_id=878
> 
> I actually prefer this (in .vimrc):
> 
> " Show trailing whitespace and spaces before tabs
> hi link localWhitespaceError Error
> au Syntax * syn match localWhitespaceError /\(\zs\%#\|\s\)\+$/ display
> au Syntax * syn match localWhitespaceError / \+\ze\t/ display
> 
> It always displays trailing whitespace and spaces-before tabs... except
> if your cursor is at the end of the whitespace.  The updating is
> occasionally a bit laggy (EG: Put spaces on a line and then move the
> cursor off it without pressing <ENTER>), but when you hit Ctrl-L, enter,
> or edit an adjacent line then it updates.

Stolen from an old message in LKML - I don't remember who's the author:

highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

Works without any glitches here (not "laggy").  But I don't use
syntax coloring - never tried if it works with coloring or not.

/mjt
