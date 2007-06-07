Return-Path: <linux-kernel-owner+w=401wt.eu-S964809AbXFGRjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809AbXFGRjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760781AbXFGRjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:39:00 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57337 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbXFGRi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:38:59 -0400
Message-ID: <4668412D.3030506@zytor.com>
Date: Thu, 07 Jun 2007 10:32:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Satyam Sharma <satyam.sharma@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: why does the macro "ZERO_PAGE" take an argument?
References: <Pine.LNX.4.64.0706070715290.14293@localhost.localdomain>  <4667EC18.4080904@yahoo.com.au>  <Pine.LNX.4.64.0706070731250.14994@localhost.localdomain> <a781481a0706070439p6dda152l37e475ae0fa698ef@mail.gmail.com> <Pine.LNX.4.64.0706070750540.16051@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0706070750540.16051@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>> The comment above empty_zero_page and zero_page_mask
>> declarations at arch/mips/mm/init.c:508 sheds light on this ...
> 
> well, it *sort of* does.  at line 64 of that file:
> 
> /*
>  * We have up to 8 empty zeroed pages so we can map one of the right colour
>  * when needed.  This is necessary only on R4000 / R4400 SC and MC versions
>  * where we have to avoid VCED / VECI exceptions for good performance at
>  * any price.  Since page is never written to after the initialization we
>  * don't have to care about aliases on other CPUs.
>  */
> 
> although it's not clear where in the source tree are the invocations
> that would actually make a difference to a MIPS system, which is why
> i've CC'ed ralf on this.  i'm sure he can clear this up. :-)

x86 could also benefit from coloured zeropages.  In fact, I thought it
already had them (K8 wants as many as 8.)

	-hpa
