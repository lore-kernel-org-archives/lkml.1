Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbZKNFNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbZKNFNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 00:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZKNFNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 00:13:13 -0500
Received: from smtp107.prem.mail.sp1.yahoo.com ([98.136.44.62]:32370 "HELO
	smtp107.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751509AbZKNFNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 00:13:12 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: dHxmVgkVM1lXmzZT.dy5npQmqo6g_yIXFYwHv3gV9IKYraIQaT14q3nRW7w1jgWilTqJID4C6DTfAxqWNmK2DIzgBNtiUpk9M.NMl8MssZKdeoUoUvF_QMl2uU5eqnl4ApzBWaGpfCUxv2WqDO_e6WicDw9Jjc60a9Yr7mOo0BAuUBh4K.7qlPyV_eUIabMQI_sC29umZ8_oTFwlndrzwL0WLVmCtsR0m4qXatU8SOOOXva9OikK.sC1gemc06_0Nxt9_OdHR1rIiAE.Uxzc3joY_SCxdwgt_sFlIzdipxXzMS.MatjbIRvKbHrLFlSsxJtkmz4Eq5EqwlKC7zo-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AFE3C53.70709@schaufler-ca.com>
Date: Fri, 13 Nov 2009 21:12:51 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: David Wagner <daw-news@taverner.cs.berkeley.edu>,
       linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk>	 <4AFCC06B.1030302@schaufler-ca.com>	 <19857.1258147396@turing-police.cc.vt.edu>	 <4AFE1EA9.60102@schaufler-ca.com>  <hdl92e$srv$1@taverner.cs.berkeley.edu> <1258170491.16857.142.camel@Joe-Laptop.home>
In-Reply-To: <1258170491.16857.142.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Sat, 2009-11-14 at 03:44 +0000, David Wagner wrote:
>   
>> I personally don't find
>>     strncmp(foo, "constant", sizeof("constant"))        // first snippet
>> to be more readable, auditable, or obviously correct than
>>     strcmp(foo, "constant").                            // second snippet
>> Is there a technical basis for arguing that the first
>> snippet is better than the second snippet?
>>     
>
> I don't think there is.
>   

And you're exactly correct. Now please go convince all the whingers
who think that even though because their tool found a "bad" thing
there is nothing to worry about. But that's beside the point. There
really is no point here. This whole discussion is around a gratuitous
change that has no net effect on the behavior of the system. Unless
you are talking about the original change proposal, which would have
broken certain cases.

I am advocating that the code be left as is. It works fine (for what it
is intended to do, of course) and the "corrected" change is just plain
unnecessary. It is no clearer and no less clear than the original. Leave
it alone unless there is a good reason to change it. What, are y'all
getting paid by the patch or something?


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   

