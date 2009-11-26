Return-Path: <linux-kernel-owner+w=401wt.eu-S1760825AbZKZQb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825AbZKZQb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760711AbZKZQb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:31:56 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:56745 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbZKZQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:31:56 -0500
Message-ID: <4B0EAD7B.90601@linux.vnet.ibm.com>
Date: Thu, 26 Nov 2009 17:31:55 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Holger.Wolf@de.ibm.com, epasch@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: Missing recalculation of scheduler tunables in case of cpu hot
 add/remove
References: <4B0EA88E.3030205@linux.vnet.ibm.com> <1259252382.31676.207.camel@laptop>  <4B0EAC06.3010407@linux.vnet.ibm.com> <1259252892.31676.220.camel@laptop>
In-Reply-To: <1259252892.31676.220.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-11-26 at 17:25 +0100, Christian Ehrhardt wrote:
>   
>>> Aside from that, we probably should put an upper limit in place, as I
>>> guess large cpu count machines get silly large values
>>>       
>> I agree to that, but in the code is already an upper limit of 
>> 200.000.000 - well we might discuss if that is too low/high.
>>     
>
> Yeah, I think we should cap it around the 8-16 CPUs.
>
>   
ok for me, driven by that finding I think I have to measure different 
kind of scalings anyway, but as usually that takes some time :-/
At least too time much for the discussion & solution of that bug I guess.

The question for now is what we do on cpu hot add/remove?
Would hooking somewhere in kernel/cpu.c be the right approach - I'm not 
quite sure about my own suggestion yet :-).

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 

