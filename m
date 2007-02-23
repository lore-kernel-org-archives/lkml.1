Return-Path: <linux-kernel-owner+w=401wt.eu-S932687AbXBWPwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbXBWPwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 10:52:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932696AbXBWPwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 10:52:08 -0500
Received: from mail.tmr.com ([64.65.253.246]:50654 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932687AbXBWPwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 10:52:06 -0500
Message-ID: <45DF0DA8.9010305@tmr.com>
Date: Fri, 23 Feb 2007 10:52:08 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
References: <20070220172544.15678.patches@notabene>	<1070220063516.16208@suse.de> <20070221144806.e6eed85c.akpm@linux-foundation.org>
In-Reply-To: <20070221144806.e6eed85c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 20 Feb 2007 17:35:16 +1100
> NeilBrown <neilb@suse.de> wrote:
>
>   
>> +		for (i = conf->raid_disks ; i-- ;  ) {
>>     
>
> That statement should be dragged out, shot, stomped on then ceremonially
> incinerated.
>
> What's wrong with doing
>
> 	for (i = 0; i < conf->raid_disks; i++) {
>
> in a manner which can be understood without alcoholic fortification?

I don't find either hard to read, but you suggestion isn't equivalent, 
since it increments rather than decrements the index.
I admit I probably would write it the same way Neil did...

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

