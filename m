Return-Path: <linux-kernel-owner+w=401wt.eu-S933084AbXDFVb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbXDFVb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXDFVb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:31:27 -0400
Received: from mail.tmr.com ([64.65.253.246]:59286 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084AbXDFVbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:31:25 -0400
Message-ID: <4616BC95.8070009@tmr.com>
Date: Fri, 06 Apr 2007 17:33:09 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Paa Paa <paapaa125@hotmail.com>
CC: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org
Subject: Re: Lower HD transfer rate with NCQ enabled?
References: <46121BCF.50401@yahoo.com.au> <BAY20-F2534ADD292CC02D5ACAFBCF9670@phx.gbl>
In-Reply-To: <BAY20-F2534ADD292CC02D5ACAFBCF9670@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paa Paa wrote:
>>> Q: What conclusion can I make on "hdparm -t" results or can I make 
>>> any conclusions? Do I really have lower performance with NCQ or not? 
>>> If I do, is this because of my HD or because of kernel?
>>
>> What IO scheduler are you using? If AS or CFQ, could you try with 
>> deadline?
> 
> I was using CFQ. I now tried with Deadline and that doesn't seem to 
> degrade the performance at all! With Deadline I got 60MB/s both with and 
> without NCQ. This was with "hdparm -t".
> 
> So what does this tell us?
> 
It suggests that it's time to test with real load and see if deadline 
works well for you in the general case.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
