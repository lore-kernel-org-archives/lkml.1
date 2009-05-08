Return-Path: <linux-kernel-owner+w=401wt.eu-S1762710AbZEHBZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762710AbZEHBZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 21:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbZEHBZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 21:25:04 -0400
Received: from main.gmane.org ([80.91.229.2]:38808 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbZEHBZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 21:25:01 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Shannon McMackin <smcmackin@gmail.com>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Thu, 07 May 2009 21:17:32 -0400
Message-ID: <gu017d$g2s$1@ger.gmane.org>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090507120948.GA1531@ucw.cz> <200905080037.19722@centrum.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: c-67-163-100-38.hsd1.va.comcast.net
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
In-Reply-To: <200905080037.19722@centrum.cz>
Cc: tuxonice-devel@lists.tuxonice.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trekker.dk@centrum.cz wrote:
> Well...
> 
>>
>> To summarise disadvantages:
>>
>> - only core has 8000 LoC
>> - it does stuff that can be easily done in userspace
>>     (and that todays distros _do_ in userspace).
>> - it duplicates uswsusp functionality.
>> - compared to [u]swsusp, it received little testing
>>
> 
> To summarise advatages - for me tuxonice is the only hibernation method that works.
> (Till now I've had 3 machines - no one of them able to resume with in-kernel swsusp.)
> 
> 
>> _______________________________________________
>> TuxOnIce-devel mailing list
>> TuxOnIce-devel@lists.tuxonice.net
>> http://lists.tuxonice.net/mailman/listinfo/tuxonice-devel
>>
> 
Just to add my 2 cents as a user of TOI.  Every distro and release I've 
tried has one major issue with kernel hibernation.  Upon resume when 
hibernating large images, there's a residual footprint in swap.  Every 
further hibernation creates a larger footprint, to the order of an 
additional 5-7% each time.  Nobody has ever cared in any forum to 
explain why or how I might change that.

TOI does not do this and that's why I've been using it on every distro I 
  can for the past 4 or 5 years.  I for one would love to see TOI 
capability added to the mainline to improve functionality and 
performance. If we can't get all 3 maintained, then 2 that are better 
would seem to suffice...

