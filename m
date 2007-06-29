Return-Path: <linux-kernel-owner+w=401wt.eu-S933061AbXF2Mtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061AbXF2Mtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763213AbXF2Mto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:49:44 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:51824 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640AbXF2Mto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:49:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QKql462IL7ldPa0YKgNJCxYuZ8tNv8viCqyvg4JCHuzUJlvvNxQYloGujiBkIdnOc2YHfCdrQ0y7ZQBL/5F4XKj5Ou5qSc7O1lJdKfbXM3EN93JLc289PtBkkRMt7i7DvwqeEu5EMmTt01Hx6sAdMxQP/hnTvzxDmAkdXTLjs4U=
Message-ID: <d120d5000706290549n9c2babfua0f4563e603835b5@mail.gmail.com>
Date: Fri, 29 Jun 2007 08:49:42 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Michael Tokarev" <mjt@tls.msk.ru>
Subject: Re: [OT] Vim highlighting for trailing spaces
Cc: "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Dave Young" <hidave.darkstar@gmail.com>,
       "Li Yang-r58472" <LeoLi@freescale.com>,
       "Josh Triplett" <josh@kernel.org>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Chris Shoemaker" <c.shoemaker@cox.net>,
       "Josh Triplett" <josht@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <4684FDAC.7000800@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46835C16.9020700@kernel.org>
	 <989B956029373F45A0B8AF0297081890D834BE@zch01exm26.fsl.freescale.net>
	 <a8e1da0706280010m1e787bc2jae999084438982da@mail.gmail.com>
	 <a8e1da0706280020ocf81ce7u98de87f16d674706@mail.gmail.com>
	 <7958FF64-140B-435A-8B69-A503C5C18D79@mac.com>
	 <4684FDAC.7000800@msgid.tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/07, Michael Tokarev <mjt@tls.msk.ru> wrote:
> Kyle Moffett wrote:
> > On Jun 28, 2007, at 03:20:24, Dave Young wrote:
> >> And for vim trailing space, there's a tip in vim.org:
> >> http://www.vim.org/tips/tip.php?tip_id=878
> >
> > I actually prefer this (in .vimrc):
> >
> > " Show trailing whitespace and spaces before tabs
> > hi link localWhitespaceError Error
> > au Syntax * syn match localWhitespaceError /\(\zs\%#\|\s\)\+$/ display
> > au Syntax * syn match localWhitespaceError / \+\ze\t/ display
> >
> > It always displays trailing whitespace and spaces-before tabs... except
> > if your cursor is at the end of the whitespace.  The updating is
> > occasionally a bit laggy (EG: Put spaces on a line and then move the
> > cursor off it without pressing <ENTER>), but when you hit Ctrl-L, enter,
> > or edit an adjacent line then it updates.
>
> Stolen from an old message in LKML - I don't remember who's the author:
>
> highlight WhitespaceEOL ctermbg=red guibg=red
> match WhitespaceEOL /\s\+$/
>
> Works without any glitches here (not "laggy").  But I don't use
> syntax coloring - never tried if it works with coloring or not.
>

That only highlights whitespace at the end of the lines. You might
want to use pattern below to also highlight "tab after space" in the
middle of the line:

:highlight RedundantSpaces ctermbg=red guibg=red
:match RedundantSpaces /\s\+$\| \+\ze\t/

-- 
Dmitry
