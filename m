Return-Path: <linux-kernel-owner+w=401wt.eu-S934045AbXC1WnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045AbXC1WnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 18:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933931AbXC1Wm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 18:42:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48433 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933814AbXC1Wm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 18:42:58 -0400
Message-ID: <460AEF65.8070908@pobox.com>
Date: Wed, 28 Mar 2007 18:42:45 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Bill Davidsen <davidsen@tmr.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, saw@saw.sw.com.sg,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [2.6 patch] the scheduled eepro100 removal
References: <20070325145810.GI16477@stusta.de> <460AE997.90509@tmr.com> <460AEB85.1020101@intel.com>
In-Reply-To: <460AEB85.1020101@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> Bill Davidsen wrote:
>> Adrian Bunk wrote:
>>> This patch contains the scheduled removal of the eepro100 driver.
>>>
>>> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>>>
>>>
>> This keeps coming around, but I haven't seen an answer to the 
>> questions raised by Eric Piel or Kiszka. I do know that e100 didn't 
>> work on some IBM rackmount servers and eepro100 did, but since I'm no 
>> longer responsible for those machines I can't retest. Perhaps someone 
>> will be able to provide data points.
>>
>> IBM current offerings as of about three years ago, I had a few dozen 
>> of them at one time.
> 
> We have provided a (test) driver which allows e100 to use IO to 
> communicate with the device, which seems to have helped for one person. 
> I think we need to work with those changes and see if it helps the other 
> people resolve their e100 issues. Unfortunately it keeps slipping off to 
> the low priority list for us.
> 
> I suggest that we should push this code into -mm for people to test or 
> something. It's fairly low risk as by default the patch won't enable IO 
> and thus use the old method of writing to the adapter.

Sounds sane to me.  My overall opinion on eepro100 removal is that we're 
not there yet.  Rare problem cases remain where e100 fails but eepro100 
works, and it's older drivers so its low priority for everybody.

Needs to happen, though...

	Jeff



