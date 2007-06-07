Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbXFGL3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbXFGL3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 07:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbXFGL3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 07:29:36 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:42678 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751033AbXFGL3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 07:29:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=UgsIg+ya7etsmQZC3j7xtgblx+L+dF/0fBg2+Fkzqn5kvAr1ji23w71suHPG38DMB/QJLwzRoKFv+jXV3KxWWE9ukzit8VzvYxl/hhpTDsAkUq9jEv2R6vvcIHZRE/1tYgtBRCCESIGbr/9+xlE6IHd8rE5EkD6jU0vCZUjZJtw=  ;
X-YMail-OSG: 12zrASEVM1n7KzBGrlLPhWAq6ZrhH9jQftZ7bT4etNBEM_EkeBcAfNPx.zeTXobqtfvf1aMN4A--
Message-ID: <4667EC18.4080904@yahoo.com.au>
Date: Thu, 07 Jun 2007 21:29:28 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why does the macro "ZERO_PAGE" take an argument?
References: <Pine.LNX.4.64.0706070715290.14293@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0706070715290.14293@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   probably making a fool of myself here, but what is the purpose of
> that single argument to the macro "ZERO_PAGE"?
> 
> $ grep -r "define ZERO_PAGE" include
> include/asm-frv/pgtable.h:#define ZERO_PAGE(vaddr)      ({ BUG(); NULL; })
> include/asm-frv/pgtable.h:#define ZERO_PAGE(vaddr)      virt_to_page(empty_zero_page)
> include/asm-v850/pgtable.h:#define ZERO_PAGE(vaddr)     ((void *)0x87654321)
> include/asm-mips/pgtable.h:#define ZERO_PAGE(vaddr) \
> include/asm-blackfin/pgtable.h:#define ZERO_PAGE(vaddr) (virt_to_page(0))
> include/asm-parisc/pgtable.h:#define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
> include/asm-alpha/pgtable.h:#define ZERO_PAGE(vaddr)    (virt_to_page(ZERO_PGE))
> ...
> 
>   AFAICT, there are no definitions of that macro that actually use
> that argument.  is that some kind of historical cruft?

MIPS?

-- 
SUSE Labs, Novell Inc.
