Return-Path: <linux-kernel-owner+w=401wt.eu-S971070AbXEIAIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971070AbXEIAIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968382AbXEIAIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:08:42 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:24299 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S967451AbXEIAIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:08:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=r1NWk40Z+A2ZY6gUknR9JGR5RLzMUYJNLenIwx5gr0wOrm70FyCH2gzKQgX+b9WUVzMYvhjbU4ZZFPE2YaIE45JDAbYzCSe5/T4dkcpXWNoAhovWdcMGNZDeb2Eq+vTcFLAwIy6nMadA6O9w5G8bIMNlS7u/C6Bg+DDu1MfRUcI=  ;
X-YMail-OSG: oPUD57gVM1m_xFHArk07_wJX9BwFZe3aMKoKWGi0IMchF82Bi6agBqbadj83KZi_pm47mmcFNw--
Message-ID: <46411102.5070301@yahoo.com.au>
Date: Wed, 09 May 2007 10:08:34 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: get_user_pages vs mmap MAP_FIXED bug
References: <1178434876.12284.175.camel@localhost.localdomain>	 <1178501204.7731.35.camel@localhost.localdomain>	 <20070506202225.ba6476b6.akpm@linux-foundation.org>	 <464029C2.1020003@yahoo.com.au> <1178667269.7286.44.camel@localhost.localdomain>
In-Reply-To: <1178667269.7286.44.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty!

Rusty Russell wrote:
> On Tue, 2007-05-08 at 17:41 +1000, Nick Piggin wrote:
> 
>>Fancy that! Thanks for catching it Rusty, does the following work for
>>you?
> 
> 
> Hi Nick,
> 
> 	After 24 hours, it seems to be holding up (the original problem showed
> up in lguest, which uses get_user_pages extensively).
> 
> Thanks!
> Rusty.

No, thank _you_ for finding the bug :)

-- 
SUSE Labs, Novell Inc.
