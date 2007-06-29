Return-Path: <linux-kernel-owner+w=401wt.eu-S933032AbXF2Hjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbXF2Hjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 03:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764445AbXF2Hjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 03:39:45 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:27985 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbXF2Hjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 03:39:44 -0400
Date: Fri, 29 Jun 2007 09:39:43 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Dave Young <hidave.darkstar@gmail.com>,
       Li Yang-r58472 <LeoLi@freescale.com>, Josh Triplett <josh@kernel.org>,
       Chris Shoemaker <c.shoemaker@cox.net>,
       Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [OT] Vim highlighting for trailing spaces
In-Reply-To: <7958FF64-140B-435A-8B69-A503C5C18D79@mac.com>
Message-ID: <Pine.LNX.4.64.0706290938460.22579@fbirervta.pbzchgretzou.qr>
References: <46835C16.9020700@kernel.org>
 <989B956029373F45A0B8AF0297081890D834BE@zch01exm26.fsl.freescale.net>
 <a8e1da0706280010m1e787bc2jae999084438982da@mail.gmail.com>
 <a8e1da0706280020ocf81ce7u98de87f16d674706@mail.gmail.com>
 <7958FF64-140B-435A-8B69-A503C5C18D79@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 28 2007 23:11, Kyle Moffett wrote:
> I actually prefer this (in .vimrc):
>
> " Show trailing whitespace and spaces before tabs
> hi link localWhitespaceError Error
> au Syntax * syn match localWhitespaceError /\(\zs\%#\|\s\)\+$/ display
> au Syntax * syn match localWhitespaceError / \+\ze\t/ display

I prefer this:

find . -type f -print0 | xargs -0 grep -Pn '[\t ]+$'

It is editor agnostic, and I do not have to look through all source files for
highlighted whitespace :-)

> The script mentioned there *is* good for removing said whitespace, though
>
> Cheers,
> Kyle Moffett
>

	Jan
-- 
