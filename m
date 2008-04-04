Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbYDDHrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbYDDHrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 03:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYDDHrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 03:47:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:26504 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYDDHrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 03:47:36 -0400
Message-ID: <47F5DC8F.9010001@oracle.com>
Date: Fri, 04 Apr 2008 13:15:19 +0530
From: Gurudas Pai <gurudas.pai@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nish Aravamudan <nish.aravamudan@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [BUG]:2.6.25-rc7 memory leak with hugepages.
References: <47EB4E2A.1040507@oracle.com> <20080327083849.GF15626@elte.hu>	 <47EB75C5.20207@oracle.com>	 <29495f1d0804032040h56f39051lcd5f707660d3c06c@mail.gmail.com> <29495f1d0804040028i795a9859y585ed0ca2413816a@mail.gmail.com>
In-Reply-To: <29495f1d0804040028i795a9859y585ed0ca2413816a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Nish Aravamudan wrote:
> On 4/3/08, Nish Aravamudan <nish.aravamudan@gmail.com> wrote:
>> On 3/27/08, Gurudas Pai <gurudas.pai@oracle.com> wrote:
>>  >  Ingo Molnar wrote:
>>  >  > * Gurudas Pai <gurudas.pai@oracle.com> wrote:
> 
> <snip>
> 
>>  On another note, it is odd that we're using the dynamic pool, when it
>>  is initially disabled...I'll have to think about that.
> 
> What is the value in /proc/sys/vm/nr_overcommit_hugepages?
> 
cat /proc/sys/vm/nr_overcommit_hugepages
0

Thanks,
-Guru
