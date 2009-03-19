Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZCSLLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZCSLLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 07:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbZCSLK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 07:10:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:2092 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbZCSLK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 07:10:56 -0400
Message-ID: <49C2283B.7010907@monstr.eu>
Date: Thu, 19 Mar 2009 12:10:51 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Microblaze linux support
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>	 <20090319072256.GA5069@elte.hu> <49C213A2.4040609@monstr.eu>	 <20090319102142.GA2579@elte.hu>  <49C21DF0.10808@monstr.eu> <1237459666.3127.8.camel@localhost.localdomain>
In-Reply-To: <1237459666.3127.8.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> On Thu, 2009-03-19 at 11:26 +0100, Michal Simek wrote:
> 
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
> externs should be in header files
> 
> EXPORT_SYMBOL should immediately follow its function/variable should
> normally be in source files like : arch/x86/kernel/process.c

Yes, I know -> is should be in all microblaze code (for example
arch/microblaze/lib folder)


> and if required can also be defined in header files like:
> arch/x86/include/asm/percpu.h

As wrote Ingo this is a little bit different case.

Thanks for you comments,
Michal
> 
> --
> JSR
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
