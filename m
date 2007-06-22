Return-Path: <linux-kernel-owner+w=401wt.eu-S1751299AbXFVMju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbXFVMju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbXFVMjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:39:40 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:40464 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910AbXFVMjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:39:39 -0400
Message-ID: <467BC306.9010008@dgreaves.com>
Date: Fri, 22 Jun 2007 13:39:34 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: david@lang.hm
Cc: Neil Brown <neilb@suse.de>, Bill Davidsen <davidsen@tmr.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <46756BE2.7010401@tmr.com> <467B03C1.50809@tmr.com> <18043.13037.40956.366334@notabene.brown> <467B840F.4080402@dgreaves.com> <Pine.LNX.4.64.0706220235590.9657@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706220235590.9657@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Fri, 22 Jun 2007, David Greaves wrote:
> 
>> That's not a bad thing - until you look at the complexity it brings - 
>> and then consider the impact and exceptions when you do, eg hardware 
>> acceleration? md information fed up to the fs layer for xfs? simple 
>> long term maintenance?
>>
>> Often these problems are well worth the benefits of the feature.
>>
>> I _wonder_ if this is one where the right thing is to "just say no" :)
> so for several reasons I don't see this as something that's deserving of 
> an atomatic 'no'
> 
> David Lang

Err, re-read it, I hope you'll see that I agree with you - I actually just meant 
the --assume-clean workaround stuff :)

If you end up 'fiddling' in md because someone specified --assume-clean on a 
raid5 [in this case just to save a few minutes *testing time* on system with a 
heavily choked bus!] then that adds *even more* complexity and exception cases 
into all the stuff you described.

I'm very much for the fs layer reading the lower block structure so I don't have 
to fiddle with arcane tuning parameters - yes, *please* help make xfs self-tuning!

Keeping life as straightforward as possible low down makes the upwards interface 
more manageable and that goal more realistic...

David
