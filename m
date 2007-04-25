Return-Path: <linux-kernel-owner+w=401wt.eu-S965655AbXDYMx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965655AbXDYMx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965661AbXDYMx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:53:57 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:47595 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965650AbXDYMx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:53:56 -0400
Message-ID: <462F4D7D.8020707@aitel.hist.no>
Date: Wed, 25 Apr 2007 14:45:49 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
References: <20070408143559.f5014629.akpm@linux-foundation.org> <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org> <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704122023510.12991@twin.jikos.cz> <20070412202519.GB14705@aitel.hist.no> <Pine.LNX.4.64.0704130107170.12991@twin.jikos.cz> <462F2558.5010909@aitel.hist.no> <Pine.LNX.4.64.0704251324540.20657@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0704251324540.20657@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Wed, 25 Apr 2007, Helge Hafting wrote:
>
>   
>>> Anyway, based on information you have provided in your later messages, 
>>> it seems that it is probably not necessairly related neither to USB 
>>> nor HID, as you are getting hangs at different stages of boot, 
>>> depending on your local configuration/kernel version used. Is vanilla 
>>> 2.6.21-rc6 ok? If so, would you have time to bisect the offending 
>>> patch?
>>>       
>> I don't know about 2.6.21-rc6, but 2.6.21-rc7 (from fresh sources) is 
>> good.  It boots up without hanging, and my USB devices works too. Should 
>> I test rc7-mm1 then?
>>     
>
> That would also be useful.
>
> But really identifying offending patch using bisection would help most. 
>   
If there is an offending patch at all - my rc6-mm1 kernel must
have been built from messed-up sources - we saw that when your
patch did not apply.  So my source had errors - right in the USB part.

I haven't tested a correct rc6-mm1, so I don't even know if it
has problems.  I can make such a kernel of course. . .
> And it should be pretty easy and not too much time consuming for you, as 
> the bug triggers immediately upon boot in your case.
>   
Indeed - it is easy to spot. :-)

Helge Hafting
