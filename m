Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbXICTvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbXICTvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 15:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbXICTvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 15:51:05 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:35221 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbXICTvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 15:51:04 -0400
Message-ID: <46DC6543.3000607@linux.vnet.ibm.com>
Date: Mon, 03 Sep 2007 20:49:23 +0100
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [-mm PATCH] Memory controller improve user interface (v3)
References: <20070902105021.3737.31251.sendpatchset@balbir-laptop> <6599ad830709022153g1720bcedsb61d7cf7a783bd3f@mail.gmail.com>
In-Reply-To: <6599ad830709022153g1720bcedsb61d7cf7a783bd3f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 9/2/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> -       s += sprintf(s, "%lu\n", *val);
>> +       if (read_strategy)
>> +               s += read_strategy(*val, s);
>> +       else
>> +               s += sprintf(s, "%lu\n", *val);
> 
> This would be better as %llu
> 

Hi, Paul,

This does not need fixing, since the other counters like failcnt are
still unsigned long

>> +               tmp = simple_strtoul(buf, &end, 10);
> 
> and this as simple_strtoull()
> 


Will do, thanks!



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
