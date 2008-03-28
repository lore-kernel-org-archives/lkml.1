Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYC1MDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYC1MDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYC1MDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:03:13 -0400
Received: from mail.tmr.com ([64.65.253.246]:51726 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbYC1MDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:03:12 -0400
Message-ID: <47ECDED6.4050100@tmr.com>
Date: Fri, 28 Mar 2008 08:04:38 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: Chris Snook <csnook@redhat.com>, Emmanuel Florac <eflorac@intellique.com>,
       linux-kernel@vger.kernel.org
Subject: Re: RAID-1 performance under 2.4 and 2.6
References: <20080325194306.4ac71ff2@galadriel.home>	 <47E975F8.3000702@redhat.com>	 <e2e108260803260015l5e8ba4f7n4fdbac771b13cbba@mail.gmail.com>	 <47EC173F.4050309@tmr.com> <e2e108260803280044o1bf41e5q8fd0b00a772b54a4@mail.gmail.com>
In-Reply-To: <e2e108260803280044o1bf41e5q8fd0b00a772b54a4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> On Thu, Mar 27, 2008 at 10:53 PM, Bill Davidsen <davidsen@tmr.com> wrote:
>   
>> Bart Van Assche wrote:
>>     
>>> On Tue, Mar 25, 2008 at 11:00 PM, Chris Snook <csnook@redhat.com> wrote:
>>>       
>>>>  It means you shouldn't use dd as a benchmark.
>>>>         
>>> If you want to benchmark write speed, you should add
>>> oflag=direct,dsync to the dd command line. For benchmarking read speed
>>> you should specify iflag=direct. Or, even better, you can use xdd with
>>> the flags -dio -processlock.
>>>       
>>  No, you want your benchmark to measure performance doing what the
>>  application does. Do unless you have an application which has been
>>  heavily Linux-ized you don't want to measure something unrelated to the
>>  application requirements.
>>     
>
> A basic fact I learned in science classes: if you measure something,
> know very well what you measure and make sure your measurement is
> repeatable. But it was some time ago I learned this. Maybe the whole
> world changed since I learned that ?
>   

Sounds like we're saying the same thing. For naive applications dd is 
probably a closer model without direct or fconv, while if you want to 
see what you could gain using additional features those are useful 
options. I believe Chris was talking about the max speed possible, which 
is a good thing to know but not similar to simple programming or shell 
scripts using sed, grep, etc.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


