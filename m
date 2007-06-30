Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbXF3AAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbXF3AAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 20:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbXF3AA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 20:00:26 -0400
Received: from smtpout.mac.com ([17.250.248.185]:63418 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbXF3AAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 20:00:25 -0400
In-Reply-To: <d120d5000706290549n9c2babfua0f4563e603835b5@mail.gmail.com>
References: <46835C16.9020700@kernel.org> <989B956029373F45A0B8AF0297081890D834BE@zch01exm26.fsl.freescale.net> <a8e1da0706280010m1e787bc2jae999084438982da@mail.gmail.com> <a8e1da0706280020ocf81ce7u98de87f16d674706@mail.gmail.com> <7958FF64-140B-435A-8B69-A503C5C18D79@mac.com> <4684FDAC.7000800@msgid.tls.msk.ru> <d120d5000706290549n9c2babfua0f4563e603835b5@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6849664D-7A3F-47CF-A976-2EFE44502E6D@mac.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Dave Young <hidave.darkstar@gmail.com>,
       Li Yang-r58472 <LeoLi@freescale.com>, Josh Triplett <josh@kernel.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Chris Shoemaker <c.shoemaker@cox.net>,
       Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [OT] Vim highlighting for trailing spaces
Date: Fri, 29 Jun 2007 20:00:19 -0400
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 29, 2007, at 08:49:42, Dmitry Torokhov wrote:
> On 6/29/07, Michael Tokarev <mjt@tls.msk.ru> wrote:
>> highlight WhitespaceEOL ctermbg=red guibg=red
>> match WhitespaceEOL /\s\+$/
>>
>> Works without any glitches here (not "laggy").  But I don't use  
>> syntax coloring - never tried if it works with coloring or not.
>>
>
> That only highlights whitespace at the end of the lines. You might  
> want to use pattern below to also highlight "tab after space" in  
> the middle of the line:
>
> :highlight RedundantSpaces ctermbg=red guibg=red
> :match RedundantSpaces /\s\+$\| \+\ze\t/

You missed the nice part about my vimrc patterns: :-D

Kyle Moffett wrote:
> It always displays trailing whitespace and spaces-before tabs...  
> except if your cursor is at the end of the whitespace.

They intentionally *don't* display whitespace at the end of the line  
to the left of your cursor.  I tried that one (that you quoted), but  
got annoyed by the fact that immediately after you typed any space or  
tab you had a little red blob to the left of the cursor.  So some of  
that "lagginess" is intentionaly (although not all of it, due to vim  
limitations).

Cheers,
Kyle Moffett
