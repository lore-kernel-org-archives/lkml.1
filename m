Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbXKMCXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbXKMCXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 21:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbXKMCX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 21:23:26 -0500
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:27673 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbXKMCXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 21:23:25 -0500
Date: Tue, 13 Nov 2007 03:23:23 +0100 (CET)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Andreas Schwab <schwab@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: top lies ?
In-Reply-To: <jer6iv57d3.fsf@sykes.suse.de>
Message-ID: <Pine.BSO.4.63.0711130319520.3123@rudy.mif.pg.gda.pl>
References: <Pine.BSO.4.63.0711121843170.3123@rudy.mif.pg.gda.pl>
 <jer6iv57d3.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-661033657-1194920603=:3123"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-661033657-1194920603=:3123
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 13 Nov 2007, Andreas Schwab wrote:

> Tomasz K³oczko <kloczek@rudy.mif.pg.gda.pl> writes:
>
>> Some data showed by top command looks like completly trashed.
>> Fragment from top output:
>>
>> Mem:   2075784k total,  2053352k used,    22432k free,    19260k buffers
>> Swap:  2096472k total,      136k used,  2096336k free,  1335080k cached
>>
>>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  SWAP nFLT WCHAN     COMMAND
>> 14515 mysql     20   0 1837m 563m 4132 S   39 27.8  27:14.20 1.2g   18 -         mysqld
>>
>> How it is possible that swap ussage is 136k and swapped out portion of (in
>> this case) mysqld process is 1.2g ?
>
> SWAP is just VIRT - RES.  It means that 1.2g of the allocated virtual
> address space is not resident, but it does not mean that all of it is
> written to the swap space, it can also be part of a file based mapping.

OK but where I can find per process data about number of 
pages/amout of memory in swap ?

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-661033657-1194920603=:3123--
