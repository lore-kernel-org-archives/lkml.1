Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbYEDIQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbYEDIQy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 04:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbYEDIQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 04:16:38 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:51100 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752515AbYEDIQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 04:16:36 -0400
Message-ID: <481D711E.6000003@seznam.cz>
Date: Sun, 04 May 2008 10:17:34 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: monstr@seznam.cz, paulus@samba.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] OF: clean coding style - prom_parse.c
References: <monstr@seznam.cz>	 <1209827626-8562-1-git-send-email-monstr@seznam.cz>	 <c382f7ff87d1502c20423742ad738e50a118cf62.1209827449.git.monstr@monstr.eu> <1209835583.16966.10.camel@localhost>
In-Reply-To: <1209835583.16966.10.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I fixed only part of coding style violation. Not all of them.

But you are right KERN_<level> is necessary.

For me is especially important to move these files from arch/powerpc to drivers/of.

M

>>  /* Debug utility */
>>  #ifdef DEBUG
>>  static void of_dump_addr(const char *s, const u32 *addr, int na)
>>  {
>> -	printk("%s", s);
>> -	while(na--)
>> -		printk(" %08x", *(addr++));
>> -	printk("\n");
>> +	printk(KERN_INFO "%s", s);
>> +	while (na--)
>> +		printk(KERN_INFO " %08x", *(addr++));
>> +	printk(KERN_INFO "\n");
>>  }
> 
> You've prefixed KERN_INFO before every address block.
> 
> How about:
> 
> print_hex_dump(KERN_<level>, s, DUMP_PREFIX_NONE, 4, addr, na, false);
> 
> 

