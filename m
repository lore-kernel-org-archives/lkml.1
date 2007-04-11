Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbXDKPmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbXDKPmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbXDKPmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:42:00 -0400
Received: from mail.tmr.com ([64.65.253.246]:35253 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbXDKPl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:41:59 -0400
Message-ID: <461CFFD7.4010304@tmr.com>
Date: Wed, 11 Apr 2007 11:33:43 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Maxim Uvarov <muvarov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, Valdis.Kletnieks@vt.edu, jesper.juhl@gmail.com
Subject: Re: Performance Stats: Kernel patch
References: <461A4C1E.3070309@ru.mvista.com>	<20070410102111.923b92a9.dada1@cosmosbay.com>	<461CCD94.6010507@ru.mvista.com> <20070411161536.926d79e1.dada1@cosmosbay.com>
In-Reply-To: <20070411161536.926d79e1.dada1@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> On Wed, 11 Apr 2007 15:59:16 +0400
> Maxim Uvarov <muvarov@ru.mvista.com> wrote:
>
>   
>> Patch adds Process Performance Statistics.
>> It make available to the user the following 
>> new per-process (thread) performance statistics:
>>    * Involuntary Context Switches
>>    * Voluntary Context Switches
>>    * Number of system calls
>>    
>> This data is useful for detecting hyperactivity 
>> patterns between processes.
>>     
>
> Your description is not very clear about the semantic of your stats.
>
> You currently returns stats only for thread(s) (not process as you claimed)
>   
I'm not sure if you were confused by his use of thread in parenthesis, 
but isn't the whole point of this to see which threads are doing what? 
Or am I misreading his result as intentional?
> Please check kernel/sys.c:k_getrusage() to see how getrusage() has to sum *lot* of individual fields to get precise process numbers (even counting stats for dead threads)
>
>   
-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

