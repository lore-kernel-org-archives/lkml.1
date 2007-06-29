Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbXF2DML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbXF2DML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 23:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764983AbXF2DL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 23:11:57 -0400
Received: from smtpout.mac.com ([17.250.248.172]:56852 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762915AbXF2DL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 23:11:57 -0400
In-Reply-To: <a8e1da0706280020ocf81ce7u98de87f16d674706@mail.gmail.com>
References: <46835C16.9020700@kernel.org> <989B956029373F45A0B8AF0297081890D834BE@zch01exm26.fsl.freescale.net> <a8e1da0706280010m1e787bc2jae999084438982da@mail.gmail.com> <a8e1da0706280020ocf81ce7u98de87f16d674706@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <7958FF64-140B-435A-8B69-A503C5C18D79@mac.com>
Cc: Li Yang-r58472 <LeoLi@freescale.com>, Josh Triplett <josh@kernel.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Chris Shoemaker <c.shoemaker@cox.net>,
       Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: [OT] Vim highlighting for trailing spaces
Date: Thu, 28 Jun 2007 23:11:51 -0400
To: Dave Young <hidave.darkstar@gmail.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 28, 2007, at 03:20:24, Dave Young wrote:
> And for vim trailing space, there's a tip in vim.org:
> http://www.vim.org/tips/tip.php?tip_id=878

I actually prefer this (in .vimrc):

" Show trailing whitespace and spaces before tabs
hi link localWhitespaceError Error
au Syntax * syn match localWhitespaceError /\(\zs\%#\|\s\)\+$/ display
au Syntax * syn match localWhitespaceError / \+\ze\t/ display

It always displays trailing whitespace and spaces-before tabs...  
except if your cursor is at the end of the whitespace.  The updating  
is occasionally a bit laggy (EG: Put spaces on a line and then move  
the cursor off it without pressing <ENTER>), but when you hit Ctrl-L,  
enter, or edit an adjacent line then it updates.

The script mentioned there *is* good for removing said whitespace,  
though

Cheers,
Kyle Moffett

