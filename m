Return-Path: <linux-kernel-owner+w=401wt.eu-S932314AbXF1WVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbXF1WVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbXF1WV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:21:26 -0400
Received: from mail.tmr.com ([64.65.253.246]:44871 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbXF1WVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:21:25 -0400
Message-ID: <468434DE.103@tmr.com>
Date: Thu, 28 Jun 2007 18:23:26 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Daniel J Blueman <daniel.blueman@gmail.com>,
       Shaohua Li <shaohua.li@intel.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New format Intel microcode...
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com> <1174610594.6598.3.camel@sli10-conroe.sh.intel.com> <6278d2220706261442u9b137c5xb6225b3f56605554@mail.gmail.com> <p731wfy5m74.fsf@bingen.suse.de> <4683BD56.7070707@tmr.com> <20070628152747.GA14519@one.firstfloor.org>
In-Reply-To: <20070628152747.GA14519@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Slashdot carried an article this morning saying that an error in Intel 
>> microcode was being fixed. However, it listed only Windows related sites 
>>     
>
> That's a little misleading. Always dangerous getting your information
> from slashdot. Let's say Intel clarified some corner 
> cases in TLB flushing that have changed with Core2 and not everybody
> got that right. I wouldn't say it was a Intel bug though.
>
>   
Given that the Slashdot note was a pointer to Microsoft and echo of 
their statements of a firmware fix, and that same information is on the 
Microsoft site, I find it hard to find fault with them as a source for 
pointers and some context on why they might be useful. If Intel has 
released new microcode to address the issue, then it seems the code 
didn't function as desired, and it doesn't matter what you call it.
>> for the "fix" download. Is this the same TLB issue? And are these really 
>>     
>
> I think so.
>
>   
That was one question.
>> fixes for Windows to flush the TLB properly the way Linux does?
>>     
>
> On newer Linux 2.6 yes. On 2.4/x86-64 you would need in theory the microcode 
> update too.  (it'll probably show up at some point at the usual place 
> http://urbanmyth.org/microcode/).  Linux/i386 is always fine.
>
> But the problem is very obscure and you can likely ignore it too. If your 
> machine crashes it's very likely something else.
>   

I don't ignore anything I can fix. An ounce of prevention is worth a 
pound of cure. My systems don't currently crash, and that's the intended 
behavior.

I was mainly concerned with this being a new issue, and curious if 
Microsoft was calling an O/S bug a "microcode fix," given that the 
average Windows user doesn't know microcode from nanotech anyway. The 
non-answer from Arjan didn't answer either, and started by calling the 
report FUD, implying that Slashdot was wrong (not about this), and 
issuing so little answer and so much obfuscation that I thought he might 
be running for President. ;-)

I'd like the microcode update, some people elsewhere speculate that user 
level code could effect reliability if not security. I worry that an old 
2.4 kernel would be an issue, even in kvm, if that were the case.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

