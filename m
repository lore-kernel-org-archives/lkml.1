Return-Path: <linux-kernel-owner+w=401wt.eu-S933021AbXF2IB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbXF2IB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 04:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbXF2IBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 04:01:50 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:29381 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759461AbXF2IBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 04:01:49 -0400
Date: Fri, 29 Jun 2007 10:01:48 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Josh Triplett <josh@kernel.org>
cc: Kyle Moffett <mrmacman_g4@mac.com>, Dave Young <hidave.darkstar@gmail.com>,
       Li Yang-r58472 <LeoLi@freescale.com>,
       Chris Shoemaker <c.shoemaker@cox.net>,
       Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [OT] Vim highlighting for trailing spaces
In-Reply-To: <4684BA77.7090804@kernel.org>
Message-ID: <Pine.LNX.4.64.0706291001320.22579@fbirervta.pbzchgretzou.qr>
References: <46835C16.9020700@kernel.org>
 <989B956029373F45A0B8AF0297081890D834BE@zch01exm26.fsl.freescale.net>
 <a8e1da0706280010m1e787bc2jae999084438982da@mail.gmail.com>
 <a8e1da0706280020ocf81ce7u98de87f16d674706@mail.gmail.com>
 <7958FF64-140B-435A-8B69-A503C5C18D79@mac.com>
 <Pine.LNX.4.64.0706290938460.22579@fbirervta.pbzchgretzou.qr>
 <4684BA77.7090804@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 29 2007 00:53, Josh Triplett wrote:
>>> I actually prefer this (in .vimrc):
>>>
>>> " Show trailing whitespace and spaces before tabs
>>> hi link localWhitespaceError Error
>>> au Syntax * syn match localWhitespaceError /\(\zs\%#\|\s\)\+$/ display
>>> au Syntax * syn match localWhitespaceError / \+\ze\t/ display
>> 
>> I prefer this:
>> 
>> find . -type f -print0 | xargs -0 grep -Pn '[\t ]+$'
>> 
>> It is editor agnostic, and I do not have to look through all source files for
>> highlighted whitespace :-)
>
>And if you really want highlighting, you can always use grep --color. :)

Been there, done that, have GREP_COLOR env variable defined!


	Jan
-- 
