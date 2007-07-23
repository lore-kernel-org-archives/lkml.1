Return-Path: <linux-kernel-owner+w=401wt.eu-S1760024AbXGWPoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbXGWPoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 11:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbXGWPn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 11:43:59 -0400
Received: from mail.tmr.com ([64.65.253.246]:46149 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbXGWPn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 11:43:58 -0400
Message-ID: <46A4CCF5.4040402@tmr.com>
Date: Mon, 23 Jul 2007 11:44:53 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ken Moffat <zarniwhoop@ntlworld.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] what should 'uptime' be on suspend?
References: <46A0210E.6010207@tmr.com> <20070720171729.GA19935@deepthought> <20070720104215.476f4cc1.randy.dunlap@oracle.com> <20070720175730.GB21550@deepthought> <46A2101D.5020400@tmr.com> <20070721162929.GA13232@deepthought>
In-Reply-To: <20070721162929.GA13232@deepthought>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Moffat wrote:
> On Sat, Jul 21, 2007 at 09:54:37AM -0400, Bill Davidsen wrote:
>   
>> So is setting it to a random number considered correct behavior? Any of 
>> the first three values I mentioned would make sense, but the value I see 
>> is neither time since resume, time since power-on to do the resume, or 
>> any of the logical uptime values. That was the whole point of the 
>> original post, the uptime reported makes no sense at all.
>>
>>     
>  I assumed you had booted for a short time, suspended, resumed, and
> then noticed the uptime was longer than time since resume.
>
>  If you think there is a bug it might help to do a cold boot, at
> some point note uptime and then immediately suspend, resume some time
> later, immediately note uptime (including local time), keep it
> running, and later monitor uptime against local time (i.e. the local
> time will let you know the change you expect to see in uptime).  You
> might also want to confirm that the local time is maintained
> correctly.
>   
I resumed this morning, uptime before the suspend was ~4 hours, suspend 
time was ~30 hours, resume took 76 sec from power-on, uptime was 2m56s. 
As originally noted, the first time I did this the "uptime" after resume 
was 6+min. First noted on suspend to ram, this was suspend to disk to 
see if that changed anything.

Just an oddity, I guess if I care I can track it myself.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

