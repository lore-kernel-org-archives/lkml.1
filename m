Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab0BBHli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:41:38 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:39289 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab0BBHlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:41:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kjQuoI/4Q76r3pRj65JC//4D0SBiLU+sDHJWaZjcYxPtBtlbu5WNbToBqPtx1JmEVu
         SS2E+M96rkevGnuYpJFCNKRBfIiS5Q9iRB/ITHUIUq4lAp80OLSjxfSl4GP2NcKB82KI
         2vf1kKyvfYN9jS9cAyRouu6V65ryFfwk7fYiY=
Message-ID: <4B67D76A.3050906@gmail.com>
Date: Mon, 01 Feb 2010 23:42:34 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Dan Carpenter <error27@gmail.com>, linux1394-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug #14487] PANIC:
 early exception 08 rip 246:10 error	ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com> <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com> <4B675534.5070107@s5r6.in-berlin.de> <4B676917.2080506@gmail.com> <4B67BC12.4080709@s5r6.in-berlin.de> <4B67C4D2.5050205@gmail.com> <4B67CC55.40301@s5r6.in-berlin.de> <4B67CCEC.2030103@s5r6.in-berlin.de>
In-Reply-To: <4B67CCEC.2030103@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/10 22:57, Stefan Richter wrote:
> Stefan Richter wrote:
>> Do I understand correctly that at this moment it is only known that the
>> bug could be
>>    - *either* a 2.6.31 ->  2.6.32 regression
>>    - *or* an x86-64 specific bug that does not occur on x86-32,
>> right?
>
> (OK, according to your other post it /is/ a regression, at least on
> x86-64 and definitely between 2.6.27 (good) and 2.6.32 (bad).)

I'll go with the bisect in the morning(late over here),
and then go from there.(just pissed at myself
for not thinking to do this at the beginning).

Justin P. Mattock
