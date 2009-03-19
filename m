Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbZCSKxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbZCSKxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 06:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZCSKw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 06:52:56 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47843 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbZCSKwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 06:52:55 -0400
Message-ID: <49C22401.60007@monstr.eu>
Date: Thu, 19 Mar 2009 11:52:49 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Microblaze linux support
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <20090319072256.GA5069@elte.hu> <49C213A2.4040609@monstr.eu> <20090319102142.GA2579@elte.hu> <49C21DF0.10808@monstr.eu> <20090319105001.GC2579@elte.hu>
In-Reply-To: <20090319105001.GC2579@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Michal Simek <monstr@monstr.eu> wrote:
> 
>> Hi Ingo,
>>> * Michal Simek <monstr@monstr.eu> wrote:
>>>
>>>> WARNING: externs should be avoided in .c files
>>>> #110: FILE: arch/microblaze/kernel/microblaze_ksyms.c:45:
>>>> +extern void __umodsi3(void);
>>>>
>>>> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
>>>> #111: FILE: arch/microblaze/kernel/microblaze_ksyms.c:46:
>>>> +EXPORT_SYMBOL(__umodsi3);
>>> externs should be in header files.
>>>
>>> The rest indeed looks like false positives. Thanks for addressing 
>>> these things so quickly!
>> you are welcome - I can quickly test and add all changes to git.
>>
>> Is it good style separate extern definition and EXPORT_SYMBOL?
>>
>> I have three choices?
>> 1. keep extern + EXPORT_SYMBOL below  - current style
>> 2. move only extern to header file
>> 3. move extern and EXPORT_SYMBOL to header.
>>
>> What is preferable way?
> 
> Where are the symbols defined - by gcc's library?

yes.

M

> 	Ingo


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
