Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbYDSKvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbYDSKvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 06:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYDSKvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 06:51:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62185 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbYDSKu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 06:50:59 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: x86: memtest bootparam
To: Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel.send@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Sat, 19 Apr 2008 12:50:13 +0200
References: <ak6MP-3wY-3@gated-at.bofh.it> <ak6MP-3wY-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JnAe5-0000kG-ID@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX199ItP+prgpjDQDlU9JQkCr+m1kSI7PGUrv8V4
 q9xAT0fIepkMt9cqfgnUeRmpqYFxZ9Yjd3RujYm1pgFivaeYal
 BmylEn8IKOhzY50t/TuZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

>> Gitweb:    
>>http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c64df70793a9c344874eb4af19f85e0662d2d3ee
>> Commit:     c64df70793a9c344874eb4af19f85e0662d2d3ee
>> Author:     Yinghai Lu <yhlu.kernel.send@gmail.com>
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> 
>>     x86: memtest bootparam

>> +    memtest=        [KNL,X86_64] Enable memtest
>> +                    Format: <integer>
>> +                    range: 0,4 : pattern number
>> +                    default : 0 <disable>

What about running multiple tests?

I'd use e.g. a bitmask: memtest=0xE will run test 2, 3 and 4.

