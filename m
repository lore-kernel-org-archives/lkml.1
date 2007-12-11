Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbXLKPZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbXLKPZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbXLKPZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:25:15 -0500
Received: from mail.tmr.com ([64.65.253.246]:47216 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbXLKPZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:25:14 -0500
Message-ID: <475EAFF9.9020405@tmr.com>
Date: Tue, 11 Dec 2007 10:42:49 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <47584E35.7030409@tmr.com> <20071208220345.GE20441@stusta.de>
In-Reply-To: <20071208220345.GE20441@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Dec 06, 2007 at 02:32:05PM -0500, Bill Davidsen wrote:
>   
>> ...
>> Sounds like a local DoS attack point to me...
>>     
>
> As long as /dev/random is readable for all users there's no reason to 
> use /dev/urandom for a local DoS...
>   

The original point was that urandom draws entropy from random, and that 
it is an an inobvious and unintentional drain on the entropy pool. At 
least that's how I read it. I certainly have programs which draw on 
urandom simply because it's a convenient source of meaningless data. I 
have several fewer since this discussion started, though, now that I 
have looked at the easy alternatives.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


