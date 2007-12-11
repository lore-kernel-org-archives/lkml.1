Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbXLKRuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbXLKRuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbXLKRus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:50:48 -0500
Received: from dvhart.com ([64.146.134.43]:48709 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbXLKRus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:50:48 -0500
Message-ID: <475ECDF6.1070404@mbligh.org>
Date: Tue, 11 Dec 2007 09:50:46 -0800
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc4-mm1
References: <20071204211701.994dfce6.akpm@linux-foundation.org>	<475EB8B5.2090104@mbligh.org> <20071211085943.4e7c77aa.randy.dunlap@oracle.com>
In-Reply-To: <20071211085943.4e7c77aa.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I can't see this compile failure posted anywhere:
>> http://test.kernel.org/results/IBM/126049/build/debug/stderr
>>
>> arch/x86/vdso/vdso32/sigreturn.S: Assembler messages:
>> arch/x86/vdso/vdso32/sigreturn.S:23: Error: suffix or operands invalid 
>> for `pop'
>>
>> arch/x86/vdso/vdso32/syscall.S:25: Error: suffix or operands invalid for 
>> `pop'
>> make[1]: *** [arch/x86/vdso/vdso32/syscall.o] Error 1
>> make: *** [arch/x86/vdso] Error 2
> 
> I see those on one build machine but not on another, so I thought
> that it was a tools issue...

If so, it's a tools issue that worked fine until -mm1, which makes
it a kernel problem in my mind ;-)

>> Nor this one:
>> http://test.kernel.org/results/IBM/126096/build/debug/stderr
>>
>> drivers/char/hvcs.c: In function â€˜hvcs_openâ€™:
>> drivers/char/hvcs.c:1180: error: wrong type argument to unary 
>> exclamation mark
> 
> See http://marc.info/?l=linux-kernel&m=119700448119646
> for patches.


Thanks,

M.
