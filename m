Return-Path: <linux-kernel-owner+w=401wt.eu-S965014AbXBFQVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965014AbXBFQVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964972AbXBFQVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:21:00 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:59052 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965041AbXBFQU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:20:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:in-reply-to:references:mime-version:content-type:message-id:cc:content-transfer-encoding:from:subject:date:to:x-mailer;
        b=dzDLUAnANjXM8ItxzhKDbKs6twrD/uCPHSSmuFiCxaLZW6cmRGsPb9kuvvSRHT+nnHLpIc/JP+Ko4x6cdnBKP6fHQ2IS1WjoIGMJLA9FPHqP8QXBEchDOwI0od4MEs9pJW9E6CZwYXP1cV5+j6AKd+Qi+3DwkTHHN+OXr4Xw/LM=
In-Reply-To: <45C8A4E9.9080304@tmr.com>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>  <20070205084523.GA21858@elte.hu>  <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu>  <1170692539.29759.856.camel@pmac.infradead.org> <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>  <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>  <1170710272.29759.894.camel@pmac.infradead.org>  <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>  <1170711587.29759.909.camel@pmac.infradead.org>  <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>  <1170712393.29759.925.camel@pmac.infradead.org>  <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>  <20070205143110.fca62b57.randy.dunlap@oracle.com>  <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org> <1170717694.29759.941.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051525320.8424@wood y.linux-foundation.org> <A77CFAF3-DFCF-44B5-8917-364D3498DB1A@gmail.com> <45C8A4E9.9080304@tmr.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <7720E26E-0A23-4DF0-8830-1209F37501DA@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Mark Rustad <mrustad@gmail.com>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Date: Tue, 6 Feb 2007 10:20:56 -0600
To: Bill Davidsen <davidsen@tmr.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 6, 2007, at 9:55 AM, Bill Davidsen wrote:

> Mark Rustad wrote:
>> On Feb 5, 2007, at 5:32 PM, Linus Torvalds wrote:
>> <snip>
>>> And I told you that you could just improve the tools that track  
>>> those
>>> dependencies ANYWAY!
>> They aren't that bad even now. Using menuconfig (I'm a fossil that  
>> just uses curses for most things), hitting ? shows what depends or  
>> selects any particular entry. That is good enough for me now.  
>> Maybe I am just willing to ask for help, but the help already  
>> seems to be there.
> I think the problem Linus referenced with not even seeing an option  
> is an issue, you can't "?" on an option you can't see. An I use  
> menuconfig also, from long habit (accessing a remote compile server  
> with slow dialup).

Yes, of course. My point was that if you are "the embedded guy" (like  
I often am) trying to turn something off, the tools show you what to  
look at already. They are currently no help if the option does not  
appear, as you say. So automatically selecting things that are  
required for something is much better than hiding too much. At least  
it is easy to find out why something is selected if you really want  
to turn it off.

If more things worked as Linus suggests, I don't think the tools need  
much in the way of improvement. It really is more about how they are  
used as they are. That is not to say that tools improvements are not  
always welcome, but the current tools seem to work pretty well.

-- 
Mark Rustad, MRustad@gmail.com


