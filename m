Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYFRO7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYFRO7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYFRO7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:59:08 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:43591 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYFRO7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:59:07 -0400
Message-ID: <4859223A.50700@s5r6.in-berlin.de>
Date: Wed, 18 Jun 2008 16:56:58 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
CC: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>, hpa <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] x86: coding style fixes to arch/x86/math-emu/reg_constant
References: <20080614204452.25378bd0@paolo-desktop>	 <48590926.5060009@movial.fi> <4d8e3fd30806180719j718a3b1ds461495c4d3de8236@mail.gmail.com>
In-Reply-To: <4d8e3fd30806180719j718a3b1ds461495c4d3de8236@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jun 18, 2008 at 3:09 PM, Dmitri Vorobiev
> <dmitri.vorobiev@movial.fi> wrote:
>> Paolo Ciarrocchi wrote:
>>>
>>> -static void fld_const(FPU_REG const *c, int adj, u_char tag)
>>> +static void fld_const(FPU_REG const * c, int adj, u_char tag)
>> ________________________________________^
>>
>> The above does not seem to me like a big improvement in code quality. A
>> false positive from checkpatch.pl?

It should obviously be

 static void fld_const(const FPU_REG *c, int adj, u_char tag)

FPU_REG is not an appropriate type name though.  Is "typedef struct
fpu__reg FPU_REG;" necessary at all?  (Removing it would create some
code churn all over x86/math-emu/ though. Maybe not desirable.)
-- 
Stefan Richter
-=====-==--- -==- =--=-
http://arcgraph.de/sr/
